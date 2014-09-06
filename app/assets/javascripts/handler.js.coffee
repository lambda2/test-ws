
#= require websocket_rails/main
window.websocket_host = "localhost:9898"
window.websocket_host = "10.18.188.119:2000"
# Core.Handler.Dispatcher = new WebSocketRails(window.websocket_host + '/websocket')

class Core.Handler
  dispatcher: new WebSocketRails(window.websocket_host + '/websocket')

  constructor: (@channelName, @eventName, @selector) ->
    @uid = undefined
    @version = 1
    @updateCache()
    # Version Channel
    @channel = @dispatcher.subscribe(@channelName)
    @last = $(@selector).val()

    @channel.bind("all", @_receiveHandshake)
    @channel.bind("feedback", @_updatedContent)
    $(@selector).on('keyup', @_keyUpEvent)
    $(@selector).on('click', @_clickEvent)

    @dispatcher.on_open = (data) =>
      @sayHello()

  diff: (current, cache)->
    _.filter(Core._diff(current, cache), (e) ->
      e.p?
    )
    # c = 0
    # l = 0
    # _diff = ""
    # _type = (if _current.length > _last.length then "i" else "d")
    # onBounds = (c, l) ->
    #   (c < _current.length || l < _last.length)
    # while _current[c] == _last[l] and onBounds(c, l)
    #   c++
    #   l++
    # if _type is "i"
    #   while _current[c] != _last[l] and onBounds(c, l)
    #     _diff += _current[c] unless c >= _current.length
    #     c++
    #   {p: l, c: _diff, t: _type}
    # else if _type is "d"
    #   while _current[c] != _last[l] and onBounds(c, l)
    #     _diff += _last[l] unless l >= _last.length
    #     l++
    #   {p: c, c: _diff, t: _type}

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

  sendRawData: (data, cursor) ->
    data = _.extend(data, {uid: @uid, v: (if cursor? then @version else @nextVersion())})
    @dispatcher.trigger("#{@channelName}.#{@eventName}", data)
    console.info("> Sending...", data)

  sendCursorPosition: (start, end) =>
    pack = {t: 'c'}
    if start > 0
      pack.s = start
      if end != start
        pack.e = end
      @sendRawData(pack, true)

  nextVersion: ->
    @version = @version + 1

  sayHello: ->
    @dispatcher.trigger("#{@channelName}.hello", {})

  _clickEvent: =>
    start = $(@selector)[0].selectionStart
    end = $(@selector)[0].selectionEnd
    @sendCursorPosition(start, end)

  _keyUpEvent: (e) =>
    cache = @last
    current = @getContent()
    @updateCache()
    d = @diff(current, cache)
    _.each(d, (e) =>
      @sendRawData(e)
    )
    e.stopImmediatePropagation();
    e.preventDefault();
    return false;

  _receiveHandshake: (data) =>
    console.warn("Reset ! > ", data)
    @_saveCursorPosition()
    $(@selector).val(data.content)
    @_restoreCursorPosition()
    @version = data.version
    @uid ?= data.uid
    @updateCache()

  _checkIntegrity: (data) ->
    checksum_ext = data.md5
    checksum = md5(@getContent())
    if checksum != checksum_ext
      console.warn("VERSION DIFFER ! (#{checksum} != #{checksum_ext})")
      @sayHello()
      return false
    else
      console.log("[md5] Ok !")
      return true

  _saveCursorPosition: ->
    @_cursor_s = $(@selector)[0].selectionStart
    @_cursor_e = $(@selector)[0].selectionEnd
    console.log("SAVE #{@_cursor_s} - #{@_cursor_e}")

  _restoreCursorPosition: (diff) ->
    console.log("RESTORE #{@_cursor_s} - #{@_cursor_e}")
    if diff != undefined
      console.log("diff")
      if diff.t is "i" and diff.p < @_cursor_s
        console.log("[before] position was in #{@_cursor_s} (#{diff.p})")
        $(@selector)[0].setSelectionRange(@_cursor_s + diff.c.length, @_cursor_e + diff.c.length)
        console.log("[after] position is now in #{@_cursor_s + diff.c.length} (#{@_cursor_s} + #{diff.c.length})")
      else if diff.t is "d" and diff.p > @_cursor_s
        $(@selector)[0].setSelectionRange(@_cursor_s - diff.c.length, @_cursor_e - diff.c.length)
      else
        $(@selector)[0].setSelectionRange(@_cursor_s, @_cursor_e)
        console.warn("AH BAH EN FAIT ON EST LA :'(")
    else
      console.log("no diff")
      console.log("[simpe, restore] position was in #{@_cursor_s}")
      $(@selector)[0].setSelectionRange(@_cursor_s, @_cursor_e)

  _updatedContent: (data) =>
    console.info("[recv] > ", data)
    if data.uid != @uid
      console.info("[Foreign package !] (from #{data.uid})")
      current = $(@selector).val()
      if data.t is "i"
        current = _.str.insert(current, data.p, data.c)
      else if data.t is "d"
        current = _.str.splice(current, data.p, data.c.length)
      @_saveCursorPosition()
      $(@selector).val(current)
      @_restoreCursorPosition(data)
      @version = data.v
      @updateCache()
      @_checkIntegrity(data)


  # attachChannelBind: (channelName, event, callback) =>
  #   channel = @dispatcher.subscribe(channelName)
  #
  #   # bind to a channel event
  #   channel.bind(event, (data) ->
  #     callback(data)
  #   )
  #   @
  #
  # attachEventBind: (channelName, chan_event, callback) =>
  #   channel = @dispatcher.subscribe(channelName)
  #
  #   # bind to a channel chan_event
  #   channel.bind(chan_event, (data) ->
  #     callback(data)
  #   )
  #   @
  #
  # simplebind: (channel, callback) =>
  #   @dispatcher.bind(channel, callback)
