(function() {
  function styleFields() {
    // Add an asterisk to the labels of required fields.
    $('input[required="required"], select[required="required"], textarea[required="required"]')
      .closest(".form-group")
      .children("label")
      .append(" <i class='fa fa-asterisk text-danger'></i>");
  }
  
  $(document).on("page:change", styleFields);
})();
