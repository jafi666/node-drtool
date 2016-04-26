'use strict'

###
Directive for creating nodes of linked-stack.
@name deviceSimulatorApp.directive:linkedStackNode
###
angular.module('deviceSimulatorApp')
.directive 'linkedStackNode', ['$compile', 'Device', 'LinkedStacks',
($compile, Device, LinkedStacks) ->

  # Default template.
  TEMPLATE = [
    '<div>'
    '  <div class="new-node">'
    '    <a ng-click="expand()" class="btn-accept">New node</a>'
    '  </div>'
    '</div>'
  ].join ''

  {
    template: TEMPLATE,
    replace: true,
    scope:
      linkedStack: '=linkedStackNode'
    link: (scope, domElement) ->

      #DOM element.
      nodeSpace = domElement

      # Devices list.
      scope.devices = []

      ###
      Loads available devices from server.
      ###
      scope.loadDevices = ->
        Device.getList()
        .then (devices) ->
          scope.devices = devices

      # UI form to create nodes.
      scope.expand = ->
        html = [
          '<div class="dir-likedstask">'
          '  <div ng-init="loadDevices()">'
          '    <form ng-submit="newNode(item)">'
          '      <div class="label">Device</div>'
          '      <select ng-model="item.device" ng-options="device.ip for device in devices" required>'
          '        <option value="" disabled selected>-- choose ip --</option>'
          '      </select>'
          '      <div class="label">Next execution time (Sec)</div>'
          '      <input type="number"'
          '        ng-model="item.executionTime"'
          '        placeholder="000"'
          '        min="0"'
          '        max="999999999" required>'
          '      <div class="options-container">'
          '        <input type="submit" class="btn-accept" value="Save">'
          '        <input type="button" ng-click="cancel()" class="btn-cancel" value="Cancel">'
          '        <div class="clear-fix"></div>'
          '      </div>'
          '    </form>'
          '  </div>'
          '</div>'
        ].join ''
        scope.compile html
        return

      ###
      Creates a node for current linkedStack.
      @param node [Object] node to append to linked-stack.
      @example node structure:
        node =
          device:
            ip: '192.168.0.1'
            model: 'zem500'
          executionTime: 10
      ###
      scope.newNode = (node) ->
        LinkedStacks.one(scope.linkedStack._id).post 'node', node
        .then (node) ->
          scope.linkedStack.nodes.push node
        , (error) ->
          alert error.data.error
        scope.compile TEMPLATE
        return

      ###
      Handles cancel button's event from UI.
      ###
      scope.cancel = ->
        scope.compile TEMPLATE
        return

      ###
      Compiles HTML string and append it to UI.
      @param html [String] should be HTML as string.
      @example
        html = '<div>Hi!</div>'
      ###
      scope.compile = (html) ->
        element = angular.element '<div/>'
        element.append html
        nodeSpace.empty()
        $compile(element) scope
        nodeSpace.append element

  }
]
