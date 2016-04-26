# Node modules
Q = require 'q'

###
Validator class, validates input values.
###
class ParentValidator

  ###
  Validates if value has a value assigned.
  @param value [String | Number | Boolen Array | Object] value to validate.
  ###
  @isValid: (value) ->
    unless value?
      error = new Error "Variable #{value} is undefined"

  ###
  Validates if value is less or equal to expected value.
  @param value [Number] value to validate.
  ###
  @isMin: (value, expected) ->
    if value > expected
      throw new Error "Value #{value} most be less than or equal to #{expected}"

  ###
  Validates if value is greater or equal to expected value.
  @param value [Number] value to validate.
  ###
  @IsMax: (value, expected) ->
    if value < expected
      throw new Error "Value #{value} most be greater than or equal to #{expected}"

  ###
  Validates if value is Number.
  @param value [String | Number | Boolen Array | Object] value to validate.
  @return number [Number] returns a valid number.
  ###
  @isNumber: (value) ->
    if isNaN value
      throw new Error "value #{value} is not number"
    number = parseInt value
    number

  ###
  Validates if input value contains just number.
  @param value [Number] value to validate.
  ###
  @validateNumber: (value) ->
    regex = /^[0-9]+$/g
    if String(value).search(regex) == -1
      throw new Error "Value #{value} should contains just numbers"

module.exports = ParentValidator
