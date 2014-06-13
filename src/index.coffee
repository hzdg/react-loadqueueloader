React = require 'react'
LoaderMixin = require 'react-loadermixin'

{PropTypes} = React
{span, img} = React.DOM

Status =
  PENDING: 'pending'
  LOADING: 'loading'
  LOADED: 'loaded'
  FAILED: 'failed'

ContextTypes =
  loadQueue: (props, propName, componentName) ->
    loadQueue = props[propName]
    if loadQueue? and typeof loadQueue['enqueue'] isnt 'function'
      console.warn "Context `#{propName}` must have an `enqueue` method for `#{componentName}`"
      return false
    true


module.exports = LoadQueueLoader = React.createClass
  displayName: 'LoadQueueLoader'
  mixins: [LoaderMixin]
  propTypes:
    loader: PropTypes.func.isRequired
    priority: PropTypes.number
  contextTypes:
    loadQueue: ContextTypes.loadQueue
  getInitialState: ->
    status: Status.PENDING
  getDefaultProps: ->
    priority: 0
  componentDidMount: ->
    return unless @state.status is Status.PENDING
    if @props.src?
      @enqueueLoad @props.src, @props.priority
  componentWillUnmount: ->
    @state.loadResult?.cancel?()
  componentWillReceiveProps: (nextProps) ->
    # If a new `src` has been provided, try to cancel a pending load (if there
    # is one), and initiate a new load. Otherwise, if a new `priorty` has been
    # provided, try to update the existing load's priority. Both cancelling and
    # priority are dependent on a `loadQueue` being in context.
    if nextProps.src isnt @props.src
      @state.loadResult?.cancel?()
      @enqueueLoad nextProps.src, nextProps.priority
    else if nextProps.priority isnt @props.priority
      @state.loadResult?.priority nextProps.priority
  enqueueLoad: (src, priority) ->
    if @context?.loadQueue?
      loader = (callback) =>
        # If the component has been unmounted since the load was enqueued, don't
        # bother starting the load now.
        return unless @isMounted()
        @setState
          status: Status.LOADING
          load: {src, callback}
      loadResult = @context.loadQueue.enqueue loader, {priority}
      @setState {loadResult}
    else
      @setState
        status: Status.LOADING
        load: {src}
  loaderDidLoad: (args...) ->
    @state.load.callback? null, args...
    # If the component has been unmounted since the load was enqueued, don't
    # bother handling the load now.
    return unless @isMounted()
    @setState status: Status.LOADED
  loaderDidError: (args...) ->
    @state.load.callback? args...
    # If the component has been unmounted since the load was enqueued, don't
    # bother handling the error now.
    return unless @isMounted()
    @setState status: Status.FAILED
  render: ->
    if not @context.loadQueue or @state.load? then @renderLoader @props.loader
    else new @props.loader
