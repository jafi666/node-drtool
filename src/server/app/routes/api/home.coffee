###
Defines the Main REST api.
@param app [Express] an instance of express app.
@param express [Express] node module.
@param actionHome [ActionCenter] instance of ActionCenter.
###
module.exports = (app, express, actionHome) ->
  router = express.Router()
  app.use '/', router

  # Main home page
  router.get '/', (req, res, next) ->
    res.render 'index'
