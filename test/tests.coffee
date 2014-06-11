{assert} = chai
{img} = React.DOM


describe 'ReactLoadQueueLoader', ->
  makeLoadQueueLoaderClass = (queue) ->
    React.createClass
      render: ->
        React.withContext
          loadQueue: queue
          => @transferPropsTo ReactLoadQueueLoader loader: img

  div = null
  loadResult = null
  queue = null
  component = null

  beforeEach ->
    div = document.createElement 'div'
    loadResult =
      _priority: 0
      then: -> this
      priority: (value) -> if value? then @_priority = value else @_priority
    enqueue = (loader, opts) ->
      enqueue.callCount ?= 0
      enqueue.callCount += 1
      if opts?.priority? then loadResult._priority = opts.priority
      loadResult
    component = makeLoadQueueLoaderClass queue = {enqueue}

  it 'queues a load', ->
    React.renderComponent (component src: 'test.png'), div
    assert queue.enqueue.callCount is 1, 'Expected enquque to have been called once'

  it 'sets priority in the queue for a load', ->
    React.renderComponent (component src: 'test.png', priority: 1), div
    assert.equal loadResult.priority(), 1

  it 'updates load priority in the queue', ->
    React.renderComponent (component src: 'test.png'), div
    assert.equal loadResult.priority(), 0
    React.renderComponent (component src: 'test.png', priority: 1), div
    assert.equal loadResult.priority(), 1
