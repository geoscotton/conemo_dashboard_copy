(function () {
    function initializeSortable() {
        $("#sortable tbody").sortable({
            handle: ".handle",
            axis: "y",
            update: function () {
                $.post($(this).data("updatePath"), $(this).sortable("serialize"));
            }
        });
        $("#sortable").disableSelection();
    }

    $(document).ready(initializeSortable);
    $(document).on("page:change", initializeSortable);
})();
