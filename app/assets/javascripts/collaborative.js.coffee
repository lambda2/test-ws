window.Core ||=
  Collaborative: {}
  Handler: {}

#= require diff
#= require handler
#= require self

class Core.Collaborative

  constructor: ->
    # if $(".edit_posts").length
    #   @ws = new Core.Handler()
    @ws = new Core.Handler("posts", "action", "textarea")
