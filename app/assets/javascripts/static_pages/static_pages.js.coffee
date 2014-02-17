jQuery ->
  $('.date-pick').datepicker
    dateFormat: 'yy-mm-dd'
    autoFocusNextInput: true
  
  if $(".industry_explanation").length > 0
    if $(".industry_explanation").children().first().hasClass("field_with_errors")
      $(".industry_explanation").show()