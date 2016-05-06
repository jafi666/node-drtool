# Own modules
TodoAction = require './api/todo-action'
PersonAction = require './api/person-action'

###
Action center class serves as factory of actions handled by objects.
It works as singleton and handles core action.
###
class ActionCenter

  ###
  Initializes the drtool database action objects,
  ###
  constructor: ->
    @actions =
      todos: new TodoAction()
      people: new PersonAction()

  ###
  Returns an action on object.
  @param actionName [String] action's name.
  @return action [Action] actions on main object.
  ###
  getAction: (actionName) ->
    @actions[actionName]

module.exports = ActionCenter
