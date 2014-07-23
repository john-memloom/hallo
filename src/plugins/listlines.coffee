#
#     horizontal rule - a plugin for Hallo to allow user to insert a horizontal rule and to 
#                       add notebook style ruled lines
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget "IKS.listlines",

    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null
      icon: null
      img: null
      style: null
      lineStyles:
        solid: true
        dotted: true

    currentStyle: 'none' # 'solid', 'dotted'
    btns: []

    populateToolbar: (toolbar) ->
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      if @options.style=='droptoggle'
        contentId = "#{@options.uuid}-#{@widgetName}-data"
        target = @_makeDropdown contentId
        buttonset.append target
        buttonset.append @_makeToolbarButton target
      else
        for lineStyle, enabled of @options.lineStyles
          continue unless enabled
          btn = @_makeActionBtn(lineStyle, enabled)
          buttonset.append btn
          @btns[lineStyle] = btn
      buttonset.hallobuttonset()
      toolbar.append buttonset
      # set initial style
      bgImage = @options.editable.element.css('background-image')
      # if (bgImage.indexOf('linear-gradient(to bottom')==0)
      if (bgImage == "linear-gradient(black 2px, transparent 2px)")
        @currentStyle = 'solid'
      else if (bgImage.indexOf('linear-gradient(to bottom')>0)
        @currentStyle = 'dotted'
      else
        @currentStyle = 'none'

    _makeDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='listlines-list ui-droplist'></div>"
      for lineStyle, enabled of @options.lineStyles
        continue unless enabled
        btn = @_makeActionBtn(lineStyle, enabled)
        contentArea.append btn
        @btns[lineStyle] = btn
      contentArea

    _makeToolbarButton: (target) ->
      btn = jQuery '<span></span>'
      btn.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'lined_lists'
        img: target.children(0).find('img').attr('src')
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      btn

    _makeActionBtn: (lineStyle, enabled) ->
      btn = jQuery '<span></span>'
      img = icon = null
      if (typeof enabled != 'boolean')
        img = enabled
      else
        icon = "icon-align-justify"
      btn.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          label: lineStyle+'_ruled_lines'
          icon: icon
          img: img
          queryState: () => 
            b = @widget.btns[lineStyle]
            return if typeof b == 'undefined'
            s = b.find('img').attr('src')
            return if typeof s == 'undefined'
            if @widget.currentStyle == lineStyle
              b.find('img').attr('src', s.replace('_off', '_on'))
            else
              b.find('img').attr('src', s.replace('_on', '_off'))
          cssClass: @options.buttonCssClass
      btn.on "click", (evt) =>
        if (@widget.currentStyle == lineStyle)
          $(evt.currentTarget.children[0]).removeClass('ui-state-active')
          @widget.currentStyle = 'none'
          @removeLines(@widget.options.editable)
        else
          $(evt.currentTarget.children[0]).addClass('ui-state-active')
          @widget.currentStyle = lineStyle
          @addLines(@widget.options.editable, lineStyle)
        @widget.options.editable.element.trigger('hallomodified')

      btn        

    addLines: (editable, lineStyle) ->
      size = getComputedStyle(editable.element[0]).lineHeight
      if (size=="normal")
        fsize = parseFloat(getComputedStyle(editable.element[0]).fontSize.slice(0,-2))
        size = fsize * 1.2
      else
        size = parseFloat(size.slice(0,-2))
      if (lineStyle == 'solid')
        # bgImage = "linear-gradient(to bottom,transparent #{size-2}px, black #{size-2}px, black 100%)"
        bgImage = "linear-gradient(black 2px, transparent 2px)"
      else
        bgcolor = getComputedStyle(editable.element[0]).backgroundColor
        bgImage = "linear-gradient(to right, #{bgcolor} 50%, transparent 51%,transparent 100%),linear-gradient(to bottom,transparent #{size-2}px, black #{size-2}px, black 100%)"

      editable.element.css('background-image', bgImage)
                      .css("background-size", "4px #{size}px")   

    removeLines: (editable) ->
      editable.element.css("background-image", "")
                      .css("background-size", "")    

)(jQuery)
