http = require 'http'
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
  req = http.request
    method: 'GET'
    hostname: 'localhost'
    port: 4444
    path: '/selenium-server/driver/?cmd=testComplete'
  , (res) ->
    body = ""
    res.setEncoding('utf8')
    res.on 'data', (chunk) -> body += chunk
    res.on 'end', -> callback(null, body == 'OK')

  req.on 'error', (e) ->
    if e.code == 'ECONNREFUSED'
      callback(null, false)
    else
      callback(e)

  req.end()
