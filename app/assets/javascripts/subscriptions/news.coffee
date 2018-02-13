jQuery(document).on 'turbolinks:load', ->
  App.cable.subscriptions.create { channel: "NewsChannel" },
    received: (data) ->
      @appendLine(data)

    connected: ->
      console.log("connect")

    appendLine: (data) ->
      html = @createLine(data)
      $(".news").html(html)

    createLine: (data) ->
      """
      <article class="chat-line">
        <span class="speaker">#{data["title"]}</span>
        <span class="body">#{data["description"]}</span>
        <span class="body">#{data["time"]}</span>
      </article>
      """