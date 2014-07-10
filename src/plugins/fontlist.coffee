#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     fontlist - a plugin for Hallo to allow user to choose from list of fonts
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget 'IKS.fontlist',
    options:
      editable: null
      toolbar: null
      uuid: ''
      fonts: [
       'Arial'
       'Times New Roman'
      ]
      buttonCssClass: null
      widget: null

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

    _prepareQueryState: ->
      queryState = (event) =>
        r = @widget.options.editable.getSelection()
        font = getComputedStyle(r.startContainer.parentElement).getPropertyValue('font-family')
        $('#' + @widget.options.uuid + '-fonts span').text(font)
      events = 'keyup paste change mouseup'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-list'></div>"
      addFont = (font) =>
        fntBtn = jQuery "<div class='font-item' style='font-family: #{font};'>#{font}</div>"
        fntBtn.on 'click', => 
          font = fntBtn.text()
          el = @widget.options.editable.element
          r = @widget.options.editable.getSelection()
          allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
          if (allOrNothing)              
            el.children().css('font-family', '')
            el.css('font-family', font)
          else
            rangy.createStyleApplier("font-family: #{font};", {normalize: true}).applyToRange(r)
          $('#' + @widget.options.uuid + '-fonts span').text(font)
          @widget.options.editable.element.trigger('change')
        fntBtn
      for font in @options.fonts
        if font == '-'
          contentArea.append('<hr />')
        else
          contentArea.append addFont font 
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdowntext
        uuid: @options.uuid
        editable: @options.editable
        label: 'fonts'
        default: 'Times'
        target: target
        targetOffset: {x:0, y:0}
        width: 100
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
