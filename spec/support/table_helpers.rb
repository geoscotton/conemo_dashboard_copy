# frozen_string_literal: true
# Thanks to Henning Koch: https://makandracards.com/makandra/763-cucumber-step-to-match-table-rows-with-capybara
# Can be used for either view or feature specs.
module ArrayMethods
  def find_row(expected_row)
    find_index do |row|
      expected_row.all? do |expected_column|
        first_column = row.find_index do |column|
          content = column.content.gsub(/[\r\n\t]+/, " ").gsub(/[ ]+/, " ").strip
          expected_content = expected_column.gsub("  ", " ").strip
          matching_parts = expected_content.split("*", -1).collect do |part|
            Regexp.escape(part)
          end
          matching_expression = /\A#{matching_parts.join(".*")}\z/
          content =~ matching_expression
        end
        if first_column.nil?
          false
        else
          row = row[(first_column + 1)..-1]
          true
        end
      end
    end
  end
end

module Reenhanced
  module Matchers
    class CheckTable
      def initialize(expected_rows, expected_options = {})
        @expected_table = expected_rows
        @ordered        = expected_options.delete(:in_order)
        @negation       = expected_options.delete(:not_in_table)
      end

      def matches?(actual_table_rows)
        if @negation
          actual_table_rows.extend ArrayMethods
          @expected_table.none? do |expected_row|
            @last_expected_row = expected_row
            # first_row = actual_table_rows.find_row(expected_row)
          end
        else
          @expected_table.all? do |expected_row|
            @last_expected_row = expected_row
            actual_table_rows.extend ArrayMethods
            first_row = actual_table_rows.find_row(expected_row)
            if first_row.nil?
              false
            else
              if @ordered
                actual_table_rows = actual_table_rows[(first_row + 1)..-1]
              else
                actual_table_rows.delete_at(first_row)
              end
              true
            end
          end
        end
      end

      def failure_message
        "Could not find the following row: #{@last_expected_row.inspect}"
      end

      def negative_failure_message
        "Found the following row: #{@last_expected_row.inspect}"
      end
    end

    def contain_table(rows, in_order = false)
      CheckTable.new(rows, in_order: in_order)
    end

    def not_contain_table(rows, in_order = false)
      CheckTable.new(rows, in_order: in_order, not_in_table: true)
    end
  end
end

RSpec::Matchers.define :contain_table do |expected_rows|
  match do |actual_rows|
    Reenhanced::Matchers::CheckTable.new(expected_rows).matches?(actual_rows)
  end
end

# Helper methods for table lookup
def table_exists_with_the_following_rows(rows, options = {})
  document = Nokogiri::HTML(rendered || page.body)
  table = document.xpath("//table//tr").collect { |row| row.xpath(".//th|td") }
  in_order = options.delete(:ordered)

  expect(table).to contain_table(rows, in_order)
end

def no_table_exists_with_the_following_rows(rows, options = {})
  document = Nokogiri::HTML(page.body)
  table = document.xpath("//table//tr").collect { |row| row.xpath(".//th|td") }
  in_order = options.delete(:ordered)

  table.should not_contain_table(rows, in_order)
end
