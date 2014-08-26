(function () {
    function styleFields() {
        // Add an asterisk to the labels of required fields.
        $('input[required="required"], select[required="required"], textarea[required="required"]')
            .closest(".form-group")
            .children("label")
            .append(" <i class='fa fa-asterisk text-danger'></i>");
        $('select.dropdown').select2({
          width: "100%",
          minimumResultsForSearch: -1,
          allowClear: true,
          containerCss: {
            "margin-top": "12px",
          },
          dropdownCss: {
            "left": "10%",
            "width": "75%"
          }
        });
        $('select.date-select').select2({
          minimumResultsForSearch: -1,
          allowClear: true,
          containerCss: {
            "margin-top": "5px",
            "margin-right": "5px"
          },
          dropdownCss: {
            "left": "31.5%",
            "width": "27%"
          }
        });
        
    }

    $(document).on("page:change", styleFields);
})();