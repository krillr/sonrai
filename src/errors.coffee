Sonrai.Errors = {}

class Sonrai.Errors.ValidationFailed extends Error
  constructor: (name, value) ->
    @message = 'Invalid value for field "' + name+'": ' + value

class Sonrai.Errors.ModelNotInstantiated extends Error
  message: "Model must be instantiated to a database item to use this function."

class Sonrai.Errors.FieldDoesNotExist extends Error
  constructor: (fieldName) ->
    @message = "Field '" + fieldName + "' does not exist."

class Sonrai.Errors.InvalidOperator extends Error
  constructor: (operator) ->
    @message = "Invalid operator: " + operator
