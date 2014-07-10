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

      buttonset.hallobuttonset()
      makeButton "Top"
      makeButton "Middle"
      makeButton "Bottom"
      toolbar.append buttonset

    verticallyAlign: (evt, alignment, el) ->
      alreadyWrapped = $(el).parent().css('display') == 'table'
      $('.'+@widgetName).find('button').removeClass('ui-state-active')
      $(evt.currentTarget.children[0]).addClass('ui-state-active')
      if (alreadyWrapped)
        switch alignment
          when 'Top' then $(el).unwrap().css('display', '').css('vertical-align', '')
          when 'Middle' then $(el).css('vertical-align', 'middle' )
          when 'Bottom' then $(el).css('vertical-align', 'bottom')
      else
        return if alignment == 'Top'
        $(el).wrap("<div style='display:table; padding-left:#{$(el).css('margin-left')};'>")
        $(el).css('display', 'table-cell').css('vertical-align', 'middle' ) if alignment == 'Middle'
        $(el).css('display', 'table-cell').css('vertical-align', 'bottom' ) if alignment == 'Bottom'


)(jQuery)      	