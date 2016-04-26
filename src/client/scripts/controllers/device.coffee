'use strict'

###
Controller of the deviceSimulatorApp.
Device controller contains functions for managing devices.
###
angular.module('deviceSimulatorApp')
.controller 'DeviceCtrl',
($scope, $state, socketSimulator, Device, IpHandler, DeviceModel, TABS, HELPER, Restangular) ->

  # Constants
  URL_REQUEST =
    STATE: 'devices/state'
    STATUS: 'changestatus'
    DEVICES: 'devices'

  # Models filter.
  $scope.modelsFilter = TABS.filters[0].value

  # Device models.
  $scope.deviceModels = []

  # New device to be created.
  $scope.newDevice =
    model: null
    ipFrom: null
    ipTo: null
    range: false

  # Contains all devices displayed on the UI.
  $scope.devices = []

  # List of all available IP addresses.
  $scope.availableIpsFrom = []

  # List of all available IP beginning from selected IP1 address.
  $scope.availableIpsTo = []

  # Socket configuration.
  SOCKET_CONFIG =
    NAME: 'simulator'
    CHANNEL: 'devices'
    ACTION: 'update'

  # Restarts IO connection
  socketSimulator.reconnect()

  # Opens socket IO channels
  socketSimulator.on SOCKET_CONFIG.NAME, (data) ->
    if data.channel is SOCKET_CONFIG.CHANNEL
      if data.action is SOCKET_CONFIG.ACTION
        device = data.element
        $scope.updateByIp device

  ###
  Initializes device models and Finds created devices.
  ###
  $scope.init = ->
    Device.getList()
    .then (devices) ->
      $scope.devices = devices
    $scope.deviceModels = DeviceModel.getList()

  ###
  Creates a new device.
  ###
  $scope.createDevice = ->
    if $scope.newDevice.model.key and
       $scope.newDevice.ipFrom

      if not $scope.newDevice.range
        newDevice =
          model: $scope.newDevice.model.key
          ipFrom: $scope.newDevice.ipFrom
          ipTo: null

      if $scope.newDevice.range and
         $scope.newDevice.ipTo
        newDevice =
          model: $scope.newDevice.model.key
          ipFrom: $scope.newDevice.ipFrom
          ipTo: $scope.newDevice.ipTo

      # Save and redirect
      if newDevice
        device = Device.post newDevice
        .then (devices) ->
          Restangular.restangularizeCollection null, devices, URL_REQUEST.DEVICES
          $scope.devices.push device for device in devices
          $scope.newDevice =
            model: null
            ipFrom: null
            ipTo: null
            range: false
          $state.go URL_REQUEST.DEVICES


  ###
  Changes devices state to turned on or turned off.
  @param state [Boolean] state device will take.
  ###
  $scope.changeDevicesState = (state) ->
    unless $scope.devices.length
      return

    Restangular.one(URL_REQUEST.STATE).post null, {state: state}
    .then null, (error) ->
      alert error.data.error

  ###
  Changes the status of the device.
  @param device [Device] the item to update.
  ###
  $scope.changeStatus = (device) ->
    device.status = !device.status
    Restangular.one(URL_REQUEST.STATUS, device._id).post null, device
    .then null, (error) ->
      alert error.data.error

  ###
  Removes a device.
  @param device [Device] the item to remove.
  ###
  $scope.removeDevice = (device) ->
    device.remove()
    .then (response) ->
      $scope.devices = _.without $scope.devices, device
    , (error) ->
      alert error.data.error

  ###
  Loads a list IPs address from server side.
  ###
  $scope.loadIps = ->
    Device.getList()
    .then (devices) ->
      IpHandler.getList()
      .then (ips) ->
        $scope.reset()
        $scope.loadValidIp devices, ips

  ###
  Sets IPs as available if it has not a device instance.
  @param devices [Array<Device>] list of created devices.
  @param ips [Array<String>] list of availables IPs.
  ###
  $scope.loadValidIp = (devices, ips) ->
    for ip in ips
      unless HELPER.existDevice devices, ip
        $scope.availableIpsFrom.push ip
        $scope.availableIpsTo.push ip

  ###
  Returns the color for the device.
  @param model ['String'] device model.
  @example
    model = 'zem500'
  ###
  $scope.getModelColor = (model) ->
    DeviceModel.getModelColor model

  ###
  Restores default values.
  ###
  $scope.reset = ->
    $scope.availableIpsFrom = []
    $scope.availableIpsTo = []

  ###
  Updates the device status by IP.
  @param deviceConfig [Object] basic device configuration.
  @example deviceConfig structure:
    deviceConfig =
      model: '192.168.49.160'
      ip: 'zem500'
      status: true
  ###
  $scope.updateByIp = (deviceConfig) ->
    angular.forEach $scope.devices, (device) ->
      if deviceConfig.ip is device.ip
        device.status = deviceConfig.status
