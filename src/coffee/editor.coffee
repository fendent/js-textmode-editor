class @Editor

    constructor: ( @id, options ) ->
        @tabstop  = 8
        @linewrap = 80
        this[k] = v for own k, v of options
        @canvas = document.getElementById(@id)
        @canvas.style.cursor = "url('data:image/cur;base64,AAACAAEAICAAAAAAAAAwAQAAFgAAACgAAAAgAAAAQAAAAAEAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8%3D'), auto"
        @width = @canvas.clientWidth
        @height = @canvas.clientHeight
        @canvas.setAttribute 'width', @width
        @canvas.setAttribute 'height', @height
        @cursor = new Cursor 8, 16, @
        @grid = []
        @ctx = @canvas.getContext '2d' if @canvas.getContext
        setInterval 'editor.draw()', 10
        $("body").bind "keydown", (e) ->
            key = 
              left: 37
              up: 38
              right: 39
              down: 40
              f1: 112
              f2: 113
              f3: 114
              f4: 115
              f5: 116
              f6: 117
              f7: 118
              f8: 119
              f9: 120
              f10: 121
              f11: 122
              f12: 123

            console.log "keydown: " + e.which
            switch e.which
              when key.left
                editor.cursor.moveLeft()
              when key.right
                editor.cursor.moveRight()
              when key.down
                if editor.cursor.y < (editor.height - editor.cursor.height) / editor.cursor.height
                  editor.cursor.y++
                  editor.cursor.draw()
              when key.up
                if editor.cursor.y > 0
                  editor.cursor.y--
                  editor.cursor.draw()
              else

        $("body").bind "keypress", (e) ->
            letter = String.fromCharCode(e.which)
            console.log "keypress: " + e.which + "/" + letter
            block = new Block(letter, 0)
            editor.grid[editor.cursor.x] = [] if !editor.grid[editor.cursor.x]            
            editor.grid[editor.cursor.x][editor.cursor.y] = block
            editor.cursor.moveRight()

    draw: ->
        @ctx.fillStyle = "#000000"
        @ctx.fillRect 0, 0, @canvas.width, @canvas.height
        @ctx.fillStyle = "#ababab"
        for x in [0..@grid.length]
            continue if !@grid[x]?
            for y in [0..@grid[x].length]
                continue if !@grid[x][y]?
                @ctx.fillRect x * @cursor.width, y*@cursor.height, @cursor.width, @cursor.height 
        @ctx.fill()
        return true

    class Block

        constructor: (@char, @attr) ->

    class Cursor

        constructor: (@width, @height, @editor) ->
            @x = 0
            @y = 0
            @dom = $("#cursor")
            @dom.width @width
            @dom.height @height
            @draw()
        draw: ->
            @dom.animate
                left: (@x+1)*@width
                top: (@y+1)*@height
                10
            return true
        moveRight: ->
            if @x < @editor.width/@width - 1
                @x++
            else if @y < @editor.height/@height - 1
                @x =0;
                @y++
            @draw()
            return true                
        moveLeft: ->
            if @x > 0
                @x--
            else if @y > 0
                @y--
                @x = @editor.width/@width - 1
            @draw()
            return true
