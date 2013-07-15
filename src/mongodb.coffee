util = require 'util'
{spawn} = require 'child_process'

exports.hasLocalMongoDatabase = hasLocalMongoDatabase = (callback) ->
  mongo = spawn('mongo', ['--eval', '42'])
  mongo.on 'exit', (code) ->
    if code == 0
      callback(null, true)
    else
      callback(null, false)

runAttempts = (count, callback) ->
  hasLocalMongoDatabase (err, hasDatabase) ->
    if err
      callback(err)
    else if hasDatabase
      callback()
    else if count == 0
      callback(new Error("Could not start mongo"))
    else
      setTimeout ->
        runAttempts(count-1, callback)
      , 1000

exports.runMongo = ({ out, err }, callback) ->

  mongod = spawn('mongod')

  util.pump(mongod.stdout, out) if out
  util.pump(mongod.stderr, err) if err

  runAttempts 10, (err) ->
    mongod.kill('SIGINT') if err?
    callback.apply(this, arguments)

  (callback) ->
    mongod.kill('SIGINT')
    callback()
