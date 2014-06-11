{assert} = chai
{img} = React.DOM


describe 'ReactLoadQueueLoader', ->
  div = null
  queue = null
  component = null


  makeLoadQueueLoaderClass = (queue) ->
    React.createClass
      getDefaultProps: -> loader: img
      renderLoader: ->
        @transferPropsTo (ReactLoadQueueLoader null)
      render: -> React.withContext loadQueue: queue, @renderLoader


  class LoadResult
    constructor: (@loader, @_priority = 0) ->
    then: -> this
    priority: (value) -> if value? then @_priority = value else @_priority


  class LoadQueue
    constructor: ->
      @_loadResults = []
      @enqueue.callCount = 0
    enqueue: (loader, opts) ->
      @enqueue.callCount += 1
      @_loadResults.push loadResult = new LoadResult loader, opts?.priority
      loadResult
    run: -> loader @run if {loader} = @_loadResults.shift()


  beforeEach ->
    div = document.createElement 'div'
    component = makeLoadQueueLoaderClass queue = new LoadQueue()

  it 'queues a load', ->
    React.renderComponent (component src: 'test.png'), div
    assert queue.enqueue.callCount is 1,
      'Expected enquque to have been called once'

  it 'sets priority in the queue for a load', ->
    React.renderComponent (component src: 'test.png', priority: 1), div
    assert.equal queue._loadResults[0].priority(), 1,
      'Expected priority to be 1'

  it 'updates load priority in the queue', ->
    React.renderComponent (component src: 'test.png'), div
    assert.equal queue._loadResults[0].priority(), 0,
      'Expected priority to be 0'
    React.renderComponent (component src: 'test.png', priority: 1), div
    assert.equal queue._loadResults[0].priority(), 1,
      'Expected priority to change to 1'
