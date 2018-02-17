jQuery(document).on 'turbolinks:load', ->
  App.cable.subscriptions.create { channel: "NewsChannel" },
    received: (data) ->
      @updateNewsAttributes(data)

    connected: ->
      console.log("connect")

    updateNewsAttributes: (data) ->
      $(".news .title").text(data["title"])
      $(".news .description").text(data["description"])
      $(".news .time").text(data["time"])