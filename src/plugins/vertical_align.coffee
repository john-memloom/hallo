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
      style: null
      alignments:
        top: true
        middle: true
        bottom: true

    populateToolbar: (toolbar) ->
      
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"

      if @options.style=='droplist'
        contentId = "#{@options.uuid}-#{@widgetName}-data"
        target = @_makeDropdown contentId
        buttonset.append target
        buttonset.append @_makeToolbarButton target
      else
        for alignment, enabled of @options.alignments
          continue unless enabled
          btn = @_makeActionBtn(alignment, enabled)
          buttonset.append btn

      buttonset.hallobuttonset()
      toolbar.append buttonset

    _makeActionBtn: (alignment, enabled) ->
      btn = jQuery '<span></span>'
      img = icon = null
      if (typeof enabled != 'boolean')
        img = enabled
      else
        icon = "icon-align-#{alignment}"
        icon = "icon-align-justify" if alignment == 'Full'
      btn.hallobutton
        uuid: @options.uuid
        editable: @options.editable
        label: alignment
        icon: icon
        img: img
        cssClass: @options.buttonCssClass
      btn.on "click", (evt) =>
        r = @options.editable.getSelection()
        @verticallyAlign(evt, alignment, @options.editable.element)
        sel = rangy.getSelection()
        sel.removeAllRanges()
        sel.addRange(r)
        @options.editable.element.trigger('hallomodified')
      btn        

    _makeDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='valign-list ui-droplist'></div>"
      for alignment, enabled of @options.alignments
        continue unless enabled
        btn = @_makeActionBtn(alignment, enabled)
        contentArea.append btn
      contentArea

    _makeToolbarButton: (target) ->
      btn = jQuery '<span></span>'
      btn.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'vertical_align'
        img: target.children(0).find('img').attr('src')
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      btn

    verticallyAlign: (evt, alignment, el) ->
      alreadyWrapped = $(el).css('display') == 'table'
      $('.'+@widgetName).find('button').removeClass('ui-state-active')
      $(evt.currentTarget.children[0]).addClass('ui-state-active')
      unless alreadyWrapped
        $(el).wrapInner('<div style="display: table-cell;"></div>')
        $(el).css('display', 'table')
      $(el).children().css('vertical-align', alignment.toLowerCase())

)(jQuery)