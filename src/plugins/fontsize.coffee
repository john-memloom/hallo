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
      r = editable.cachedSelection
      allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
      if (allOrNothing)              
        el.find('*').css('font-size', '')
        el.css('font-size', size + 'px')
      else
        rangy.createStyleApplier("font-size: #{size}px;", {normalize: true}).applyToRange(r)
      editable.element.trigger('hallomodified')

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
      buttonElement

    _prepareQueryState: ->
      queryState = (event) =>
        # @widget.options.editable.element.focus()
        setTimeout =>
          console.log('query state', event)
          r = @widget.options.editable.getSelection()
          size = getComputedStyle(r.startContainer.parentElement).getPropertyValue('font-size').slice(0,-2)
          el = $('#' + @widget.options.uuid + '-font_size input')[0]
          $(el).val(size)
        , 300
      events = 'keyup paste change mouseup hallomodified'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

)(jQuery)

