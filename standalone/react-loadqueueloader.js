!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var o;"undefined"!=typeof window?o=window:"undefined"!=typeof global?o=global:"undefined"!=typeof self&&(o=self),o.ReactLoadQueueLoader=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
var ContextTypes, LoadQueueLoader, PropTypes, React, Status, img, span, _ref,
  __slice = [].slice;

React = (window.React);

PropTypes = React.PropTypes;

_ref = React.DOM, span = _ref.span, img = _ref.img;

Status = {
  PENDING: 'pending',
  LOADING: 'loading',
  LOADED: 'loaded',
  FAILED: 'failed'
};

ContextTypes = {
  loadQueue: function(props, propName, componentName) {
    var loadQueue;
    loadQueue = props[propName];
    if ((loadQueue != null) && typeof loadQueue['enqueue'] !== 'function') {
      console.warn("Context `" + propName + "` must have an `enqueue` method for `" + componentName + "`");
      return false;
    }
    return true;
  }
};

module.exports = LoadQueueLoader = React.createClass({
  displayName: 'LoadQueueLoader',
  statics: {
    Status: Status
  },
  propTypes: {
    loader: PropTypes.func.isRequired,
    src: PropTypes.string,
    priority: PropTypes.number,
    onLoad: PropTypes.func,
    onError: PropTypes.func
  },
  contextTypes: {
    loadQueue: ContextTypes.loadQueue
  },
  getInitialState: function() {
    return {
      status: Status.PENDING
    };
  },
  getDefaultProps: function() {
    return {
      priority: 0
    };
  },
  componentDidMount: function() {
    if (this.state.status !== Status.PENDING) {
      return;
    }
    if (this.props.src != null) {
      return this.enqueueLoad(this.props.src, this.props.priority);
    }
  },
  componentWillUnmount: function() {
    var _ref1;
    return (_ref1 = this.state.loadResult) != null ? typeof _ref1.cancel === "function" ? _ref1.cancel() : void 0 : void 0;
  },
  componentWillReceiveProps: function(nextProps) {
    var _ref1, _ref2;
    if (nextProps.src !== this.props.src) {
      if ((_ref1 = this.state.loadResult) != null) {
        if (typeof _ref1.cancel === "function") {
          _ref1.cancel();
        }
      }
      return this.enqueueLoad(nextProps.src, nextProps.priority);
    } else if (nextProps.priority !== this.props.priority) {
      return (_ref2 = this.state.loadResult) != null ? _ref2.priority(nextProps.priority) : void 0;
    }
  },
  enqueueLoad: function(src, priority) {
    var loadResult, loader;
    loader = (function(_this) {
      return function(callback) {
        if (!_this.isMounted()) {
          return;
        }
        return _this.setState({
          status: Status.LOADING,
          load: {
            src: src,
            callback: callback
          }
        });
      };
    })(this);
    loadResult = this.context.loadQueue.enqueue(loader, {
      priority: priority
    });
    return this.setState({
      loadResult: loadResult
    });
  },
  handleLoad: function() {
    var args, _ref1;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    (_ref1 = this.state.load).callback.apply(_ref1, args);
    if (!this.isMounted()) {
      return;
    }
    return this.setState({
      status: Status.LOADED
    }, (function(_this) {
      return function() {
        var _base;
        return typeof (_base = _this.props).onLoad === "function" ? _base.onLoad.apply(_base, args) : void 0;
      };
    })(this));
  },
  handleError: function() {
    var args, _ref1;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    (_ref1 = this.state.load).callback.apply(_ref1, args);
    if (!this.isMounted()) {
      return;
    }
    return this.setState({
      status: Status.FAILED
    }, (function(_this) {
      return function() {
        var _base;
        return typeof (_base = _this.props).onError === "function" ? _base.onError.apply(_base, args) : void 0;
      };
    })(this));
  },
  render: function() {
    var _ref1;
    return this.props.loader({
      src: (_ref1 = this.state.load) != null ? _ref1.src : void 0,
      onLoad: this.handleLoad,
      onError: this.handleError
    });
  }
});

},{}]},{},[1])
(1)
});