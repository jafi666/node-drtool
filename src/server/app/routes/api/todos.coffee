###

###
module.exports = (app, express, todoAction) ->
  router = express.Router()
  app.use '/todos', router

  # Gets all todos stored.
  router.get '/', (req, res, next) ->
    todoAction.findAll()
    .then (todos) ->
      res.json todos
    .fail (error) ->
      next error

  # Gets a single to do by Id.
  router.get '/:id', (req, res, next) ->
    todoAction.findOne req.params.id
    .then (todo) ->
      res.json todo
    .fail (error) ->
      next error

  # Creates a to do .
  router.post '/', (req, res, next) ->
    todoAction.create req.body
    .then (post) ->
      res.json post
    .fail (error) ->
      next error
