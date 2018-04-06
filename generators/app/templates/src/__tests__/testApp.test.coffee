assert = require 'assert'
testApp = require '../index'

describe 'testApp', ->
  it 'Cson imported', ->
    assert testApp?.SomeData is 'Here is some cson data',
      'cson import failure'
