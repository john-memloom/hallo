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
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"

      insertHR = jQuery '<span></span>'
      insertHR.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        label: "insertHR"
        icon: 'icon-minus'
        cssClass: @options.buttonCssClass
        command: 'insertHorizontalRule'
      buttonset.append insertHR

      toggleLines = jQuery '<span></span>'
      toggleLines.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        label: "toggleLines"
        icon: 'icon-align-justify'
        cssClass: @options.buttonCssClass

      if @options.editable.element.css("background-image") == "linear-gradient(#eee 2px, transparent 2px)"
        toggleLines.children()[0].addClass('ui-state-active')

      buttonset.append toggleLines

      toggleLines.on "click", (evt) =>
        if ($(evt.currentTarget.children[0]).hasClass('ui-state-active'))
          @removeLines(@widget.options.editable)
          $(evt.currentTarget.children[0]).removeClass('ui-state-active')
        else
          @addLines(evt, @widget.options.editable)
          $(evt.currentTarget.children[0]).addClass('ui-state-active')

      buttonset.hallobuttonset()
      toolbar.append buttonset

      @options.editable.element.on 'change', (evt) => @addLines(evt, @options.editable)
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on 'change', (evt) => @addLines(evt, @options.editable)
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off 'change', (evt) => @addLines(evt, @options.editable)


    addLines: (evt, editable) ->
      return unless $(evt.currentTarget.children[0]).hasClass('ui-state-active')
      r = editable.getSelection()
      size = getComputedStyle(r.startContainer.parentElement).getPropertyValue('line-height')
      if size == "normal"
        fsize = parseFloat(getComputedStyle(r.startContainer.parentElement).getPropertyValue('font-size').slice(0,-2))
        size = (fsize * 1.2)+"px"
      editable.element.css("background-image", "linear-gradient(#eee 2px, transparent 2px)")
                      .css("background-size", "100% #{size}")        

    removeLines: (editable) ->
      editable.element.css("background-image", "")
                      .css("background-size", "")        

)(jQuery)      	