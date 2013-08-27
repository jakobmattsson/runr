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

exports.up = (name args, callback) ->
  runr[name].isRunning (err, isRunning) ->
    return callback(err) if err?
    return callback() if isRunning
    runr[name].run(args, callback)
  