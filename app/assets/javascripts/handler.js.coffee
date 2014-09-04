
#= require websocket_rails/main
window.websocket_host = "http://10.18.188.119:2000"
window.websocket_host = "http://localhost:2000"
Core.Handler.Dispatcher = new WebSocketRails(window.websocket_host + '/websocket')

class Core.Handler
  dispatcher: Core.Handler.Dispatcher
  version: 1

  constructor: (@channelName, @eventName) ->
    @dispatcher.trigger('posts.update', {text: "aaaaaaaaaah !"})
    # console.log("Handler is on the road ! [#{@channelName} <> #{@eventName}]")
    # @channel = @dispatcher.subscribe(@channelName)
    # @channel.bind(@eventName, (data) ->
    #   console.warn("Data received ! => ", data)
    # )

  sendData: (position, type, content) ->
    pack =
      p: position
      t: if type.length > 1 then type[0] else type
      c: content
      v: @nextVersion()
    console.info("Ready to send package: #{pack}")
    if not @channel
      console.warn("Unable to connect to #{window.websocket_host}/websocket")
    else

  nextVersion: ->
    @version = @version + 1

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
