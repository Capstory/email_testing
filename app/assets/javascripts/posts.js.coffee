@PostPoller =
  poll: ->
    @poll_timer = setTimeout @request, 5000
    
  request: ->
    $.get($("#original_container").data('url'), after: $('.post').first().data('id'))
    
  clear: ->
    clearTimeout(@poll_timer)

@SlideshowPoller =
  poll: ->
    setTimeout @request, 5000
  
  request: ->
    data_id = $("#maximage").attr('data-id')
    $.get($("#maximage").data('url'), after: data_id)

jQuery ->
  if $("#original_container").length > 0
    PostPoller.poll()
    
  if $("#maximage").length > 0
    SlideshowPoller.poll()