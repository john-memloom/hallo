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
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target
      # put the increment buttons in their own buttonset      
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append @_makeSizerButton("up")
      buttonset.append @_makeSizerButton("down")

    _makeSizerButton: (direction) ->
      buttonHolder = jQuery '<span></span>'
      buttonHolder.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        icon: if direction=="up" then 'icon-caret-up' else 'icon-caret-down'
        label: if direction=="up" then 'increase font size' else 'decrease font size'
      buttonHolder

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-size-list'></div>"
      currentFont = @options.editable.element.get(0).tagName.toLowerCase()
      addSize = (size) =>
        el = jQuery "<div class='font-size-item'>#{size}x</div>"
        el.on 'click', =>
          font = el.text()
        el
      for size in @options.sizes
        contentArea.append addSize size 
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdownedit
        uuid: @options.uuid
        editable: @options.editable
        label: 'font size'
        default: '1x'
        size: 2
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
