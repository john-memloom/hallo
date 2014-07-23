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
      icon: null
      img: null

    populateToolbar: (toolbar) ->
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      insertHR = jQuery '<span></span>'
      img = icon = null
      img = @options.img
      icon = @options.icon || 'icon-minus' unless img
      insertHR.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        label: "insert_horizontal_rule"
        icon: icon
        img: img
        cssClass: @options.buttonCssClass
        command: 'insertHorizontalRule'
      buttonset.append insertHR
      buttonset.hallobuttonset()
      toolbar.append buttonset


)(jQuery)      	