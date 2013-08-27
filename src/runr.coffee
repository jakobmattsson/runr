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

exports.up = (name, args, callback) ->
  exports[name].isRunning (err, isRunning) ->
    return callback(err) if err?
    return callback() if isRunning
    exports[name].run(args, callback)
  