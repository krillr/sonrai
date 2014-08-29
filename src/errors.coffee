Errors = {}

class Errors.ValidationFailed extends Error
  constructor: (value) ->
    @message = 'Invalid value: ' + value

class Errors.ModelNotInstantiated extends Error
  message: "Model must be instantiated to a database item to use this function."

class Errors.FieldDoesNotExist extends Error
  constructor: (fieldName) ->
    @message = "Field '" + fieldName + "' does not exist."

class Errors.InvalidOperator extends Error
  constructor: (operator) ->
    @message = "Invalid operator: " + operator
