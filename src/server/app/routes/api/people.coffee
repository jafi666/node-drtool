###
API route for handling people data.
###
module.exports = (app, express, peopleAction) ->
  router = express.Router()
  app.use '/people', router

  # Gets all people stored.
  router.get '/', (req, res, next) ->
    peopleAction.findAll()
    .then (people) ->
      res.json people
    .fail (error) ->
      next error

  # Gets a single person by Id.
  router.get '/:id', (req, res, next) ->
    peopleAction.findOne req.params.id
    .then (person) ->
      res.json person
    .fail (error) ->
      next error

  # Creates a person.
  router.post '/', (req, res, next) ->
    peopleAction.create req.body
    .then (post) ->
      res.json post
    .fail (error) ->
      next error