react-loadqueueloader
=====================

Sometimes you want to take the decisions about what to load and when from the
browser, but still reap the benefits of queuing and prioritizing that the
browser is capable of. A load queue (such as [queueup.js]) allows you to manage
and prioritize loads in just such a way, and this [React] component allows an
easy way of hooking asset loading for components into a load queue.


Basic Usage
-----------

```javascript
var LoadQueueLoader = require('react-loadqueueloader');

// ...

<LoadQueueLoader
  src="/path/to/image.jpg"
  priority={ 1 }
  loader={ React.DOM.img }
/>

```

While the above example nicely illustrates basic usage, it neglects a crucial
piece of the puzzle: the load queue!


Load Queue
----------

When you render the LoadQueueLoader component, you want to do so with a
`loadQueue` (such as [queueup.js]) in context (using `React.withContext`).
For example:

```javascript
var LoadQueueLoader = require('react-loadqueueloader');
var queue = require('queueup')();
var LoadQueue = React.createClass({
  render: function() {
    React.withContext({loadQueue: queue}, <div>{ this.props.children }</div>);
  }
});

// ...

<LoadQueue>
  <LoadQueueLoader src="/path/to/image.jpg" loader={ React.DOM.img } />
</LoadQueue>

```


Context
-------

<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </thead>
  <tbody>
    <tr>
      <td><code>loadQueue</code></td>
      <td>object</td>
      <td>An object that manages loads in a queue. It is expected to have an
          <code>enqueue</code> method that takes a function that performs the
          load. When the load queue is ready to load an asset, it should call
          the provided function, passing it a callback. That callback will be
          called when the load completes or errors.</td>
    </tr>
  </tbody>
</table>


Props
-----

<table>
  <thead>
    <th>Name</th>
    <th>Type</th>
    <th>Description</th>
  </thead>
  <tbody>
    <tr>
      <td><code>loader</code></td>
      <td>function</td>
      <td>A React class or other function that returns a component instance
          that loads a <code>src</code>. The instance should also accept
          <code>onLoad</code> and <code>onError</code> callbacks. Required.</td>
    </tr>
    <tr>
      <td><code>src</code></td>
      <td>string</td>
      <td>The URL of the image to be loaded.</td>
    </tr>
    <tr>
      <td><code>priority</code></td>
      <td>number</td>
      <td>The priority to assign to this load, relative to other loads in the
          queue. This prop has no effect if there is no <code>loadQueue</code>
          in the component context. Defaults to <code>0</code></td>
    </tr>
    <tr>
      <td><code>onLoad</code></td>
      <td>function</td>
      <td>An optional callback to be called when the load finishes.</td>
    </tr>
    <tr>
      <td><code>onError</code></td>
      <td>function</td>
      <td>An optional callback to be called if the load fails.</td>
    </tr>
  </tbody>
</table>


[React]: http://facebook.github.io/react/
[queueup.js]: http://github.com/hzdg/queueup.js/
