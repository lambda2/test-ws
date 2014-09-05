
#= require websocket_rails/main
window.websocket_host = "localhost:9898"
window.websocket_host = "10.18.188.119:2000"
# Core.Handler.Dispatcher = new WebSocketRails(window.websocket_host + '/websocket')

class Core.Handler
  dispatcher: new WebSocketRails(window.websocket_host + '/websocket')
  version: 1

  constructor: (@channelName, @eventName, @selector) ->
    console.log("Handler is on the road ! [#{@channelName}.#{@eventName}]")

    @updateCache()
    # Version Channel
    @channel = @dispatcher.subscribe(@channelName)
    @last = $(@selector).val()

    @channel.bind("all", (data) =>
      console.warn("Hello ! <=>", data)
      $(@selector).val(data.content)
      @updateCache()
    )


    @channel.bind("action", (data) =>
      console.warn("Hello ! <=>", data)
      $(@selector).val(data.content)
      @updateCache()
    )

    @channel.bind(@eventName, (data) =>
      console.warn("Data received ! => ", data)
      current = $(@selector).val()
      if data.t is "i"
        console.log("insert")
        current = _.str.insert(current, data.p, data.c)
      else if data.t is "d"
        current = _.str.splice(current, data.p, data.c.length)
        console.log("delete")
      $(@selector).val(current)
      @updateCache()
    )

    $(@selector).on('keyup', (event, a, b) =>
      current = @getContent()
      @sendRawData(_.extend(@diff(), {v: @nextVersion()}))
      @updateCache()
    )

    @dispatcher.on_open = (data) =>
      console.log('Connection has been established: ', data)
      @sayHello()

  diff: ->
    c = 0
    l = 0
    _diff = ""
    _current = @getContent()
    _last = @last
    _type = (if _current.length > _last.length then "i" else "d")
    onBounds = (c, l) ->
      (c < _current.length || l < _last.length)
    while _current[c] == _last[l] and onBounds(c, l)
      c++
      l++
    if _type is "i"
      while _current[c] != _last[l] and onBounds(c, l)
        _diff += _current[c]
        c++
      {p: l, c: _diff, t: _type}
    else if _type is "d"
      while _current[c] != _last[l] and onBounds(c, l)
        _diff += _last[l]
        l++
      {p: c, c: _diff, t: _type}

  getContent: ->
    $(@selector).val()

  updateCache: (callback) ->
    @last = $(@selector).val()

  sendData: (position, type, content) ->
    pack =
      p: position
      t: if type.length > 1 then type[0] else type
      c: content
      v: @nextVersion()
    @sendRawData(pack)

  sendRawData: (data) ->
    @dispatcher.trigger("#{@channelName}.#{@eventName}", data)

  nextVersion: ->
    @version = @version + 1

  sayHello: ->
    @dispatcher.trigger("#{@channelName}.hello", {})


  # attachChannelBind: (channelName, event, callback) =>
  #   channel = @dispatcher.subscribe(channelName)
  #
  #   # bind to a channel event
  #   channel.bind(event, (data) ->
  #     console.log("Event => ", data)
  #     callback(data)
  #   )
  #   @
  #
  # attachEventBind: (channelName, chan_event, callback) =>
  #   channel = @dispatcher.subscribe(channelName)
  #
  #   # bind to a channel chan_event
  #   channel.bind(chan_event, (data) ->
  #     console.log("Event => ", data)
  #     callback(data)
  #   )
  #   @
  #
  # simplebind: (channel, callback) =>
  #   @dispatcher.bind(channel, callback)
