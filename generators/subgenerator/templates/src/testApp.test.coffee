# Tests are done using mocha, coffeescript, and ES6
# You can customize options sent to coffeescript for
# testing by editing test/loader.coffee

import assert from 'assert'
import testApp from './'

describe 'testApp', ->
  it 'Cson imported', ->
    assert.strictEqual testApp.SomeData, 'Here is some cson data'
