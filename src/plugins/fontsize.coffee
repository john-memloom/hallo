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
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-size-list'></div>"
      currentFont = @options.editable.element.get(0).tagName.toLowerCase()
      addSize = (size) =>
        el = jQuery "<div class='font-size-item'>#{size}</div>"
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
        default: 12
        size: 2
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
