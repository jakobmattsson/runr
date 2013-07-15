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
