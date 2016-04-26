###
  Gets the client view port bounds
###
getViewport = ->
  viewPortWidth = undefined
  viewPortHeight = undefined

  # the more standards compliant browsers (mozilla/netscape/opera/IE7)
  # use window.innerWidth and window.innerHeight
  unless typeof window.innerWidth is "undefined"
    viewPortWidth = window.innerWidth
    viewPortHeight = window.innerHeight

    # IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)
  else if typeof document.documentElement isnt "undefined" and
  typeof document.documentElement.clientWidth isnt "undefined" and
  document.documentElement.clientWidth isnt 0
    viewPortWidth = document.documentElement.clientWidth
    viewPortHeight = document.documentElement.clientHeight

    # older versions of IE
  else
    viewPortWidth = document.getElementsByTagName("body")[0].clientWidth
    viewPortHeight = document.getElementsByTagName("body")[0].clientHeight
  [
    viewPortWidth
    viewPortHeight
  ]

###
  Helper to attach new listeners
###
addEvent = (elem, type, eventHandle) ->
  return  if not elem? or typeof (elem) is "undefined"
  if elem.addEventListener
    elem.addEventListener type, eventHandle, false
  else if elem.attachEvent
    elem.attachEvent "on" + type, eventHandle
  else
    elem["on" + type] = eventHandle
  return

###
  Resize the main card container
###
cardsContainerResizer = ->
  container = document.getElementById("cards-container")

setTimeout (->
  cardsContainerResizer()
  return
), 500

###
  Attaches cardsContainerResizer into resize event
###
addEvent window, "resize", cardsContainerResizer
