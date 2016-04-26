###
A key-value pair map collection.
###
class Map

  ###
  Initialize a Map object
  ###
  constructor: ->
    @data = {}

  ###
  Sets a key-value pair map
  @param key [string] The key
  @param value [object] The value
  ###
  set: (key, value) ->
    @data[key] = value

  ###
  Gets the value for the specified key
  @param key [string] The key for which to get the value
  ###
  get: (key) ->
    @data[key]

  ###
  Removes a value specified by key
  @param key [string] The specified key
  ###
  remove: (key) ->
    delete @data[key]

  ###
  Clears the contents of the map
  @return [undefined]
  ###
  clear: ->
    @data = {}
    return

  ###
  Gets the length of the map
  @return [number] The length of the map
  ###
  length: ->
    @keys().length

  ###
  Verifies if the map is empty
  @return [boolean] true if map is empty; otherwise, false
  ###
  isEmpty: ->
    for key in @keys()
      return false
    return true

module.exports = Map
