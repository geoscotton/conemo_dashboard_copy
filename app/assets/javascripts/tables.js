// see http://stackoverflow.com/questions/17147821/how-to-make-a-whole-row-in-a-table-clickable-as-a-link
$(document).on("ready page:change", function() {
  $(".clickable-row").click(function() {
    Turbolinks.visit($(this).data("href"));
  });
});
