'use strict';

describe 'PleaseWait', ->
  it 'defines start & finish', ->
    expect(pleaseWait.start).toBeDefined()
    expect(pleaseWait.finish).toBeDefined()