mongodb = require './mongodb'
selenium = require './selenium'

exports.selenium = {
  isRunning: selenium.isSeleniumRunning
  run: selenium.runSelenium
}

exports.mongodb = {
  run: mongodb.runMongo
  isRunning: mongodb.hasLocalMongoDatabase
}

setNow = if typeof setImmediate != 'undefined' then setImmediate else (callback) -> setTimeout(callback, 0)

exports.up = (name, args, callback) ->
  exports[name].isRunning (err, isRunning) ->
    # We always want to return a function, so the interface remains uniform
    # If "up" started the process, then calling the function kills if.
    # If "up" did not start the process, then calling the function does nothing.
    if err?
      setNow(-> callback(err))
      return ->
    if isRunning
      setNow(callback)
      return ->
    exports[name].run(args, callback)
  