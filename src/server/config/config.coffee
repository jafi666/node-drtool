path     = require 'path'
rootPath = path.normalize __dirname + '/../../..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'drtool'
    port: 3001
    db:
      NAME: 'mongoDB'
      host: "localhost"
      port: "27017"
      name: "drtool_dev"

  production:
    root: rootPath
    app:
      name: 'drtool'
    port: 3000

    db:
      NAME: 'mongoDB'
      host: "localhost"
      port: "27017"
      name: "drtool_prod"


module.exports = config[env]
