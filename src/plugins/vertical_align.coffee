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
      makeButton = (alignment) =>
        btn = jQuery '<span></span>'
        btn.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          label: alignment
          icon: "icon-question-sign"
          cssClass: @options.buttonCssClass
        buttonset.append btn
        btn.on "click", (evt) =>
          @verticallyAlign(evt, alignment, @options.editable.element)
          @options.editable.element.trigger('hallomodified')

      buttonset.hallobuttonset()
      makeButton "Top"
      makeButton "Middle"
      makeButton "Bottom"
      toolbar.append buttonset

    verticallyAlign: (evt, alignment, el) ->
      alreadyWrapped = $(el).css('display') == 'table'
      $('.'+@widgetName).find('button').removeClass('ui-state-active')
      $(evt.currentTarget.children[0]).addClass('ui-state-active')
      unless alreadyWrapped
        $(el).wrapInner('<div style="display: table-cell;"></div>')
        $(el).css('display', 'table')
      $(el).children().css('vertical-align', alignment.toLowerCase())


)(jQuery)      	