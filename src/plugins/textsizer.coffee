((jQuery) ->
  jQuery.widget "IKS.textsizer",

    options:
      uuid: ''
      editable: null
      modifier: 0.05
      max: null
      min: null
      bounded: false
    autoSizeButton: null



    populateToolbar: (toolbar) ->
      widget = this
      buttonset = jQuery "<span class=\"#{widget.widgetName}\"></span>"

      _autoSize = () ->
        el = widget.options.editable.element
        sz = px2num(getComputedStyle(el[0]).getPropertyValue('font-size'))
        el.children().css('font-size', '')
        if (el.text().trim() == '')
          el.css('font-size', "#{el.height()}px")
        else
          safeguard = 200
          while (safeguard-- > 0 && el[0].scrollHeight <= el.height())
            el.css('font-size', "#{++sz}px")
          while (safeguard-- > 0 && el[0].scrollHeight > el.height())
            el.css('font-size', "#{--sz}px")
          console.log("SAFEGUARD TRIPPED!") if (safeguard <= 0)

      @autoSizeButton = jQuery '<span></span>'
      @autoSizeButton.hallobutton
            uuid: @options.uuid
            editable: @options.editable
            icon: 'icon-fullscreen'
            label: 'automatically size the text'
      @autoSizeButton.on "click", (event) ->
        widget.autoSizeButton.children().toggleClass('ui-state-active')
        _autoSize() if (widget.autoSizeButton.children().hasClass('ui-state-active'))

      makeSizerButton = (up) =>
        buttonHolder = jQuery '<span></span>'
        buttonHolder.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          icon: if up then 'icon-caret-up' else 'icon-caret-down'
          label: if up then 'increase font size' else 'decrease font size'
        buttonset.append buttonHolder
        buttonHolder.on "click", (event) ->
          if (widget.autoSizeButton.children().hasClass('ui-state-active'))
            widget.autoSizeButton.children().toggleClass('ui-state-active')
          el = widget.options.editable.element
          r = widget.options.editable.getSelection()
          allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
          sz = 0
          lastSz = 0

          _clipSz = () ->
            max = widget.options.max
            min = widget.options.min
            sz = max if max && sz>max
            sz = min if min && sz<min

          _calcSz = () ->
            if (allOrNothing)
              sz = px2num(getComputedStyle(widget.options.editable.element[0]).getPropertyValue('font-size'))
            else
              sz = px2num(getComputedStyle(r.getNodes()[0].parentElement).getPropertyValue('font-size'))
            lastSz = sz
            if (up)
              sz *= (1+widget.options.modifier)
            else
              sz *= 1/(1+widget.options.modifier)
            
          _applySz = () ->
            if (allOrNothing)              
              el.children().css('font-size', '')
              el.css('font-size', "#{sz}px")
            else
              rangy.createStyleApplier("font-size: #{sz}px;", {normalize: true}).applyToRange(r)

          _boundSz = () ->
            if (el.height() < el[0].scrollHeight)
              sz = lastSz
              _applySz()

          _calcSz()
          _clipSz()
          _applySz()
          _boundSz() if widget.options.bounded
          widget.options.editable.restoreSelection r
          widget.options.editable.setModified(true)
          return false

      @options.editable.element.on "hallomodified", (event, data) ->
        _autoSize() if widget.autoSizeButton.children().hasClass('ui-state-active')

      makeSizerButton(false)
      makeSizerButton(true)
      buttonset.append(@autoSizeButton)
      buttonset.hallobuttonset()
      toolbar.append buttonset

)(jQuery)