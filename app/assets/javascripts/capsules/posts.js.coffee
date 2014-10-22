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
    data_id = $("#slideshow").attr('data-id')
    $.get($("#slideshow").data('url'), after: data_id)


jQuery ->
  if $("#original_container").length > 0
    PostPoller.poll()
    
  if $("#slideshow").length > 0
    url_array = []
    $("line_item").each ->
      url_array.push($(this).html())
    capsule_slideshow.set_slideshow_array(url_array)
    SlideshowPoller.poll()
