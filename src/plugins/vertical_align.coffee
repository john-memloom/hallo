#
#     verticalalign - a plugin for Hallo to allow user to set vertical alignment of text
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget "IKS.verticalalign",

    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null

    populateToolbar: (toolbar) ->
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      buttonize = (alignment) =>
        buttonElement = jQuery '<span></span>'
        buttonElement.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          label: alignment
          icon: "icon-glass"
          cssClass: @options.buttonCssClass
        buttonset.append buttonElement

      buttonize "Top"
      buttonize "Middle"
      buttonize "Bottom"

      buttonset.hallobuttonset()
      toolbar.append buttonset

)(jQuery)      	