@PostPoller =
  poll: ->
    @poll_timer = setTimeout @request, 5000
    
  request: ->
    $.get($("#original_container").data('url'), after: $('.post').first().data('id'))
    
  clear: ->
    clearTimeout(@poll_timer)
      
jQuery ->
  if $("#original_container").length > 0
    PostPoller.poll()