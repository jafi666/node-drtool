# Node modules
Q = require 'q'

# Own modules
ParentValidator = require './parent-validator'

###
Validator class, validates input values.
###
class Validator extends ParentValidator

  ###
  Validates if card value has correct expression.
  @param cardId [String | Number] user card id.
  ###
  @isCard: (cardId) ->
    deferred = Q.defer()
    if cardId
      @validateNumber cardId
      cardId = @isNumber cardId
      @isMin cardId, 2147483647
      @IsMax cardId, 0
      deferred.resolve cardId
    else
      deferred.resolve null
    deferred.promise

  ###
  Validates if object rule contains correct correct properties.
  @param rule [Object] object to validate.
  @examle rule structure:
    rule =
      events: '1'
      interval: '1'
      card: 11212
  ###
  @isRule: (rule) ->
    deferred = Q.defer()
    @isCard rule.card
    .then =>
      try
        @isValid rule.events
        @isValid rule.interval
        @validateNumber rule.events
        @validateNumber rule.interval
        deferred.resolve()
      catch error
        deferred.reject error
    deferred.promise

module.exports = Validator
