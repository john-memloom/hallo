#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     fontlist - a plugin for Hallo to allow user to choose from list of fonts
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#
((jQuery) ->
  jQuery.widget 'IKS.linespace',
    options:
      editable: null
      toolbar: null
      uuid: ''
      sizes: [1, 1.5, 2]
      buttonCssClass: null

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

    _makeSizerButton: (direction) ->
      btn = jQuery '<span></span>'
      btn.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        icon: if direction=="up" then 'icon-caret-up' else 'icon-caret-down'
        label: if direction=="up" then 'increase line height' else 'decrease line height'
      btn
      btn.on "click", =>
        currentSize = $('#' + @widget.options.uuid + '-linespace input').val().slice(0,-1)
        if (direction=="up")
          size = parseFloat(currentSize) + 0.1 
        else
          size = parseFloat(currentSize) - 0.1 
          size = 0.1 if (size < 0.1)
        size = Math.round(size * 10) / 10
        @widget.setSize(size)

    setSize: (size) ->
      el = @widget.options.editable.element
      r = @widget.options.editable.getSelection()
      allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
      lh = "" + size + 'em' 
      lh = 'normal' if size=='1' || size==1
      if (allOrNothing)              
        el.find('*').css('line-height', '')
        el.css('line-height', lh)
      else
        r.selectNode(r.commonAncestorContainer)
        rangy.createStyleApplier("line-height: #{lh};", {normalize: true, elementTagName: "div"}).applyToRange(r)
      $('#' + @widget.options.uuid + '-line_space input').val(size+"x")
      sel = rangy.getSelection()
      sel.removeAllRanges()
      sel.addRange(r)
      @widget.options.editable.element.trigger('hallomodified')
      
    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='linespace-list ui-droplist'></div>"
      currentFont = @options.editable.element.get(0).tagName.toLowerCase()
      addSize = (size) =>
        el = jQuery "<div class='linespace-item ui-text-only'>#{size}</div>"
        el.on 'click', =>
          @widget.setSize(size)
        el
      for size in @options.sizes
        contentArea.append addSize size 
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      icon = null
      icon = "icon-text-height" unless @options.img
      buttonElement.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'line_space'
        icon: icon
        img: @options.img
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      buttonElement

    _prepareQueryState: ->
      queryState = (event) =>
        r = @widget.options.editable.getSelection()
        el = r.startContainer.parentElement || @widget.options.editable.element[0]
        size = getComputedStyle(el).getPropertyValue('line-height')
        if size=='normal'
          size = 1
        else
          size = parseFloat(size.slice(0, -2))
          fsize = parseFloat(getComputedStyle(el).getPropertyValue('font-size').slice(0,-2))
          size = (size / fsize)
          size = Math.round(size*10)/10
        $('#' + @widget.options.uuid + '-linespace input').val(size + 'x')
        items = $('.linespace-item')
        items.removeClass('selected')
        item = items.filter (idx, el) =>
          $(el).text().trim() == ('' + size)
        item.addClass('selected')

      events = 'keyup paste change mouseup hallomodified'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

)(jQuery)
