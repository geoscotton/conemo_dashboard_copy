class MakePlannedActivitiesNotPullable < ActiveRecord::Migration
  def up
    TokenAuth::SynchronizableResource.where(class_name: PlannedActivity).each do |resource|
      resource.update! is_pullable: false
    end
  end

  def down
    TokenAuth::SynchronizableResource.where(class_name: PlannedActivity).each do |resource|
      resource.update! is_pullable: true
    end
  end
end
