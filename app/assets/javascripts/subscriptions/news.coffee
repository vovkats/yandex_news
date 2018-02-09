jQuery(document).on 'turbolinks:load', ->
  App.cable.subscriptions.create { channel: "NewsChannel" },
    received: (data) ->
      console.log(data)
      @appendLine(data)

    connected: ->
      console.log("connect")

    appendLine: (data) ->
      console.log("test")
      console.log(data);
      html = @createLine(data)
      $(".news").append(html)

    createLine: (data) ->
      console.log(data)
      """
      <article class="chat-line">
        <span class="speaker">#{data["title"]}</span>
        <span class="body">#{data["description"]}</span>
        <span class="body">#{data["time"]}</span>
      </article>
      """