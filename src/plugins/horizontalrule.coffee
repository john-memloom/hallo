#
#     horizontal rule - a plugin for Hallo to allow user to insert a horizontal rule and to 
#                       add notebook style ruled lines
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget "IKS.horizontalrule",

    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null

    populateToolbar: (toolbar) ->
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      makeButton = (label, icon, cmd) =>
        btn = jQuery '<span></span>'
        btn.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          label: label
          icon: icon
          cssClass: @options.buttonCssClass
          command: cmd
        buttonset.append btn

      insertHR = makeButton "Insert one horizontal line", "icon-minus", 'insertHorizontalRule'
      addLines = makeButton "Turn on horizontal ruled lines for page", "icon-align-justify", null

      buttonset.hallobuttonset()
      toolbar.append buttonset

)(jQuery)      	