assert = require 'assert'
testApp = require './index.coffee'

describe 'testApp', ->
  it 'Cson imported', ->
    assert.strictEqual testApp.SomeData, 'Here is some cson data'
