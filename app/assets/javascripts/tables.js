(function() {
  "use strict";

  function addFilterAndPagination() {
    if ($.fn.dataTable.isDataTable("table.filterable")) {
      return;
    }

    $("table.filterable").DataTable({
      "ordering": false,
      "language": { "url": "<%= root_url %>/datatable.json" }
    });
  }

  $(document).on("ready page:load", function() {
    // see http://stackoverflow.com/questions/17147821/how-to-make-a-whole-row-in-a-table-clickable-as-a-link
    $(".clickable-row").click(function() {
      Turbolinks.visit($(this).data("href"));
    });

    addFilterAndPagination();
  });
})();
