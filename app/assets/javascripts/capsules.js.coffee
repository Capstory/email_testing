window.onImageUpload = ->
  $(".pick_file").addClass("disabled")
  $("#filepicker_modal").foundation('reveal', 'open', {
    closeOnBackgroundClick: false
  })
  $("#filepicker_submit_button").click()

