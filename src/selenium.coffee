wd = require 'wd'
phantomjs = require 'phantomjs'
util = require 'util'
{spawn} = require 'child_process'

once = (f) ->
  called = false
  ->
    return if called
    called = true
    f.apply(this, arguments)

exports.runSelenium = ({ seleniumPath, out, err }, callback) ->

  onceCallback = once(callback)

  selenium = spawn('java', ['-jar', seleniumPath])

  selenium.stdout.on 'data', (data) ->
    if /Started SocketListener/.test(data.toString())
      onceCallback()

  selenium.stderr.on 'data', (data) ->
    if /^execvp\(\)/.test(data)
      onceCallback('Failed to start selenium. Please ensure that java is in your system path')

  util.pump(selenium.stdout, out) if out
  util.pump(selenium.stderr, err) if err

  (callback) ->
    selenium.kill('SIGINT')
    callback()

exports.isSeleniumRunning = (callback) ->
  browser = wd.remote()
  browser.init { browserName: 'phantomjs' }, (err) ->
    return callback(null, false) if err?
    browser.quit (err) ->
      return callback(err) if err?
      callback(null, true)
