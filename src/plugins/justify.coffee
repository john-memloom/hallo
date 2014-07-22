#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget "IKS.hallojustify",
    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null
      style: null
      alignments:
        left: true
        center: true
        right: true
        full: true

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
        command: "justify#{alignment}"
        icon: icon
        img: img
        cssClass: @options.buttonCssClass
      btn        

    _makeDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='halign-list ui-droplist'></div>"
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
        label: 'horizontal_align'
        img: target.children(0).find('img').attr('src')
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      btn


)(jQuery)


