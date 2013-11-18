@PostPoller =
  poll: ->
    setTimeout @request, 5000
    
  request: ->
    $.get($("#original_container").data('url'), after: $('.post').first().data('id'))
    
jQuery ->
  if $("#original_container").length > 0
    PostPoller.poll()