#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget "IKS.halloreundo",
    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null
      undoImg: null
      redoImg: null

    populateToolbar: (toolbar) ->
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      buttonize = (cmd) =>
        buttonElement = jQuery '<span></span>'
        icon = null
        img = if cmd is 'undo' then @options.redoImg else @options.undoImg
        unless img
          icon = if cmd is 'undo' then 'icon-undo' else 'icon-repeat'
        buttonElement.hallobutton
          uuid: @options.uuid + cmd
          editable: @options.editable
          label: cmd
          icon: icon
          img: img
          command: cmd
          queryState: false
          cssClass: @options.buttonCssClass
        buttonset.append buttonElement

      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      buttonize "undo"
      buttonset.hallobuttonset()
      toolbar.append buttonset

      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      buttonize "redo"
      buttonset.hallobuttonset()
      toolbar.append buttonset

)(jQuery)
