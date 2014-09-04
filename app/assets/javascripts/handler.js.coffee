
#= require websocket_rails/main

Core.Handler.Dispatcher = new WebSocketRails(window.location.hostname + ':9876/websocket')

class Core.Handler
  dispatcher: Core.Handler.Dispatcher

  console.info("Dispatcher is alive ! => ", @dispatcher)

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
