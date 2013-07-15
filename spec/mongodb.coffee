jscov = require 'jscov'
should = require 'should'
mongodb = require(jscov.cover('..', 'lib', 'mongodb'))

describe 'test', ->
