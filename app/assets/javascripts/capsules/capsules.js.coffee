window.onImageUpload = ->
  $(".pick_file").addClass("disabled")
  $("#filepicker_modal").foundation('reveal', 'open', {
    closeOnBackgroundClick: false
  })
  PostPoller.clear(PostPoller.poll_timer)
  $("#filepicker_submit_button").click()

$('.date-pick').datepicker
  dateFormat: 'yy-mm-dd'
  autoFocusNextInput: true