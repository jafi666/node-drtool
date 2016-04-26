'use strict'

###
Factory in the deviceSimulatorApp.
@name deviceSimulatorApp.DeviceModel
###
angular.module('deviceSimulatorApp')
  .factory 'DeviceModel', (COLORS) ->

    ###
    The list of devices.
    ###
    deviceModel =
      models: [
        {
          _id: '0'
          name: 'Zem500'
          key: 'zem500'
          color: COLORS.list[0]
        }
        {
          _id: '1'
          name: 'Zem600'
          key: 'zem600'
          color: COLORS.list[1]
        }
        {
          _id: '2'
          name: 'Zem650'
          key: 'zem650'
          color: COLORS.list[2]
        }
      ]

    ###
    Returns the models device list.
    ###
    deviceModel.getList = ->
      deviceModel.models

    ###
    Creates a new device.
    @params model [Object] device model.
    @example
    model =
      name: 'Zem500'
      value: 'zem500'
      key: 'zem500'
    ###
    deviceModel.post = (model) ->
      if model.name and model.key and model.color
        deviceModel.models.push model
      else
        console.log "Error"

    ###
    Returns the color for the device.
    @params modelKey [String] model Key.
    @example modelKey
    modelKey = 'zem500' | 'zem600'
    ###
    deviceModel.getModelColor = (modelKey) ->
      color = ""
      color = model.color for model in deviceModel.models when model.key is modelKey
      color

    # The deviceModel factory
    deviceModel
