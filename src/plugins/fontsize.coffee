#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     fontlist - a plugin for Hallo to allow user to choose from list of fonts
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#
((jQuery) ->
  jQuery.widget 'IKS.fontsize',
    options:
      editable: null
      toolbar: null
      uuid: ''
      sizes: [8,9,10,11,12,14,18,24,30,36,48,60,72,96]
      buttonCssClass: null
      withInputField: false

    populateToolbar: (toolbar) ->
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target
      # put the increment buttons in their own buttonset      
      # buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      # toolbar.append buttonset
      # buttonset.hallobuttonset()
      # buttonset.append @_makeSizerButton("up")
      # buttonset.append @_makeSizerButton("down")
      @_prepareQueryState()
      @_updateToolbarDisplay()


    _makeSizerButton: (direction) ->
      btn = jQuery '<span></span>'
      btn.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        icon: if direction=="up" then 'icon-caret-up' else 'icon-caret-down'
        label: if direction=="up" then 'increase font size' else 'decrease font size'
      btn.on "click", =>
        currentSize = $('#' + @widget.options.uuid + '-font_size input').val().slice(0,-2)
        if (direction=="up")
          size = parseInt(currentSize,10) + 1 
        else
          size = parseInt(currentSize,10) - 1 
          size = 0 if (size < 0)
        @widget.setSize(size)

    setSize: (size, editable) ->
      editable ||= @widget.options.editable
      el = editable.element
      if (@widget.options.withInputField==true)
        r = editable.cachedSelection
      else
        r = editable.getSelection()
      # rCopy = r
      allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
      if (allOrNothing)              
        el.find('*').css('font-size', '')
        el.css('font-size', size + 'px')
      else
        rangy.createStyleApplier("font-size: #{size}px;", {normalize: true}).applyToRange(r)
      unless (@widget.options.withInputField==true)
        $('#' + @widget.options.uuid + '-font_size').find('.inner-text').text(size)

      sel = rangy.getSelection()
      sel.removeAllRanges()
      sel.addRange(r)

      editable.element.trigger('hallomodified', {triggeredBy: 'fontsize'})

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-size-list ui-droplist'></div>"
      addSize = (size) =>
        el = jQuery "<div class='font-size-item ui-text-only'>#{size}</div>"
        el.on 'click', =>
          @widget.setSize(size)
      for size in @options.sizes
        contentArea.append addSize size 
      contentArea

    _prepareButton: (target) ->

      buttonElement = jQuery '<span></span>'

      if @options.withInputField
        buttonElement.hallodropdownedit
          uuid: @options.uuid
          editable: @options.editable
          label: 'font_size'
          default: '14'
          size: 3
          change: @widget.setSize
          target: target
          targetOffset: {x:0, y:0}
          cssClass: @options.buttonCssClass
      else
        buttonElement.hallodropdowntext
          uuid: @options.uuid
          editable: @options.editable
          label: 'font_size'
          default: '14'
          width: 50
          change: @widget.setSize
          target: target
          targetOffset: {x:0, y:0}
          cssClass: @options.buttonCssClass

      buttonElement

    _updateToolbarDisplay: ->

      r = @widget.options.editable.getSelection()
      el = r.startContainer.parentElement
      if el 
        if (@widget.options.editable.element.closest(el).length > 0)
          el = @widget.options.editable.element[0]
      else
        el = @widget.options.editable.element[0]
      if (r.startOffset == r.endOffset) && (r.startOffset == 0) && (el.firstElementChild != null) && (typeof el.firstElementChild != 'undefined')
        el = el.firstElementChild 
      size = getComputedStyle(el).getPropertyValue('font-size').slice(0,-2)
      if (@widget.options.withInputField==true)
        $('#' + @widget.options.uuid + '-font_size input').val(size)
      else
        $('#' + @widget.options.uuid + '-font_size').find('.inner-text').text(size)

      sz1 = parseInt(size)
      items = $('.font-size-item')
      items.removeClass('selected')
      first = true
      found = false
      items.each (idx,item) =>
        item = $(item)
        sz2 = parseInt(item.text())
        if (sz1==sz2)
          item.addClass('selected')
          found = true
          return false
        if (sz1 < sz2)
          if first
            item.addClass('selected')
          else
            item.previousSibling.addClass('selected')
          found = true
          return false
      items.last().addClass('selected') unless found

    _prepareQueryState: ->
      queryState = (event) =>
        if (@widget.options.withInputField==true)
          setTimeout =>
            @_updateToolbarDisplay()
          , 300
        else
          @_updateToolbarDisplay()

      events = 'keyup paste change mouseup hallomodified'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

)(jQuery)

