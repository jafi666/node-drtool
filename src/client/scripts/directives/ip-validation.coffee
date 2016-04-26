'use strict'

###*
 # @ngdoc function
 # @name deviceSimulatorApp.directive:ipValidation
 # @description
 # # ipValidation
 # Directive that validate the Ips
###

ValidIpAddressRegex = new RegExp "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
  "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
  "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\." +
  "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

angular.module('deviceSimulatorApp')
  .directive 'ipValidation', ['$http', ($http) ->
    {
      restrict: 'A'
      require: 'ngModel'
      link: (scope, ele, attrs, ngModel) ->
        ###
        Check if the IP is available
        ###
        isAvailable = (value) ->
          $http.get '/iphandler'
          .success (data, status, headers, cfg) ->
              available = false
              available = true for ip in data when ip is value
              ngModel.$setValidity 'ipavailable', available
          .error (data, status, headers, cfg) ->
            ngModel.$setValidity 'ipavailable', true

        ###
        Check if the IP is valid
        ###
        isValid = (value) ->
          if ValidIpAddressRegex.test(value)
            ngModel.$setValidity 'ipvalidate', true
            true
          else
            # it is invalid, return undefined (no model update)
            ngModel.$setValidity 'ipvalidate', false
            false

        ###
        Check if the IPs are duplicated
        ###
        isDuplicated = (valueFrom, valueTo) ->
          if valueFrom is valueTo
            ngModel.$setValidity 'ipduplicate', false
            true
          else
            ngModel.$setValidity 'ipduplicate', true
            false

        ###
        Check if the IP range is valid
        ###
        isValidRange = (fromIp, toIp) ->
          if not fromIp or not toIp
            ngModel.$setValidity 'iprange', false
            return false

          from = fromIp.split '.'
                .map (item) ->
                  parseInt item

          to = toIp.split '.'
                .map (item) ->
                  parseInt item

          # TODO validates if the IP is over the range
          index = 3
          from = from[index]
          toAux = to[index]
          to.pop()

          if fromIp.indexOf(to.join '.') > -1 and from < toAux
            ngModel.$setValidity 'iprange', true
            true
          else
            ngModel.$setValidity 'iprange', false
            false

        ###
        Validate the Ip from or to
        ###
        validate = (ip) ->
          switch attrs.name
            when 'ipfrom'
              ipFrom = ip
              if ngModel.$isEmpty ipFrom
                return undefined

              if isValid ipFrom
                isAvailable ipFrom
                if scope.$parent.newDevice.range and
                   scope.$parent.newDevice.ipTo and
                   not isValidRange(ipFrom, scope.$parent.newDevice.ipTo) or
                   isDuplicated(ipFrom, scope.$parent.newDevice.ipTo)
                  undefined
                else
                  ipFrom
            when 'ipto'
              ipTo = ip
              if ngModel.$isEmpty ipTo
                return undefined

              if isValid ipTo
                isAvailable ipTo
                if scope.$parent.newDevice.range and
                   scope.$parent.newDevice.ipFrom and
                   not isValidRange(scope.$parent.newDevice.ipFrom, ipTo) or
                   isDuplicated(scope.$parent.newDevice.ipFrom, ipTo)
                  undefined
                else
                  ipTo

        ngModel.$parsers.unshift validate
        ngModel.$formatters.unshift validate
    }
  ]
