import assert from 'assert'
import testApp from './'

describe 'testApp', ->
  it 'Cson imported', ->
    assert.strictEqual testApp.SomeData, 'Here is some cson data'
