#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     fontlist - a plugin for Hallo to allow user to choose from list of fonts
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#
((jQuery) ->
  jQuery.widget 'IKS.columns',
    options:
      editable: null
      toolbar: null
      uuid: ''
      sizes: [1, 2, 3, 4]
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
      @_prepareQueryState()

    setSize: (cols) ->
      el = @widget.options.editable.element
      r = @widget.options.editable.getSelection()
      allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
      return if (cols==0 || cols==@_getCurrentCols())
      if (allOrNothing)
        el.css('column-count', cols)
        el.css('column-gap', '20px')
        el.css('-moz-column-count', cols)
        el.css('-moz-column-gap', '20px')
        el.css('-webkit-column-count', cols)
        el.css('-webkit-column-gap', '20px')
      else
        template = "column-count: #{cols}; column-gap: 20px;"
        style = template
        style += template.replace(/column-/g, '-moz-column-')
        style += template.replace(/column-/g, '-webkit-column-')
        rangy.createStyleApplier(style, {normalize: true, elementTagName: "div"}).applyToRange(r)

      $('#' + @widget.options.uuid + '-columns input').val(cols + ' col')
      @widget.options.editable.element.trigger('hallomodified')
      
    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-size-list'></div>"
      currentFont = @options.editable.element.get(0).tagName.toLowerCase()
      addSize = (size) =>
        el = jQuery "<div class='font-size-item'>#{size} col</div>"
        el.on 'click', =>
          size = el.text().trim().slice(0,-3) 
          @widget.setSize(size)
        el
      for size in @options.sizes
        contentArea.append addSize size 
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdownedit
        uuid: @options.uuid
        editable: @options.editable
        label: 'columns'
        default: '1'
        size: 2
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      buttonElement

    _getCurrentCols: () ->
      r = @widget.options.editable.getSelection()
      el = r.startContainer.parentElement || @widget.options.editable.element[0]
      c = getComputedStyle(el).getPropertyValue('column-count') ||
          getComputedStyle(el).getPropertyValue('-moz-column-count') ||
          getComputedStyle(el).getPropertyValue('-webkit-column-count') 
      parseInt(c, 10) || 1

    _prepareQueryState: ->
      queryState = (event) =>
        size = @_getCurrentCols()
        $('#' + @widget.options.uuid + '-columns input').val(size + ' col')
      events = 'keyup paste change mouseup hallomodified'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

)(jQuery)
