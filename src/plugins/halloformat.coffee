#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget "IKS.halloformat",
    options:
      editable: null
      uuid: ''
      formattings:
        bold: true
        italic: true
        strikeThrough: false
        underline: false
      buttonCssClass: null

    populateToolbar: (toolbar) ->
      widget = this
      buttonset = jQuery "<span class=\"#{widget.widgetName}\"></span>"

      buttonize = (format, enabled) =>
        buttonHolder = jQuery '<span></span>'
        img = icon = null
        if (typeof enabled != 'boolean')
          img = enabled
        else  
          icon = format
        buttonHolder.hallobutton
          label: format
          editable: @options.editable
          command: format
          icon: icon
          img: img
          uuid: @options.uuid
          cssClass: @options.buttonCssClass
        buttonset.append buttonHolder

      for format, enabled of @options.formattings
        continue unless enabled
        buttonize format, enabled

      buttonset.hallobuttonset()
      toolbar.append buttonset
)(jQuery)
