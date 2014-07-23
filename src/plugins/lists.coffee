#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget "IKS.hallolists",
    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null
      style: null
      lists:
        ordered: true
        unordered: true

    populateToolbar: (toolbar) ->
      
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"

      if @options.style=='droptoggle'
        contentId = "#{@options.uuid}-#{@widgetName}-data"
        target = @_makeDropdown contentId
        buttonset.append target
        buttonset.append @_makeToolbarButton target
      else
        for list, enabled of @options.lists
          continue unless enabled
          btn = @_makeActionBtn(list, enabled)
          buttonset.append btn

      buttonset.hallobuttonset()
      toolbar.append buttonset

    _makeActionBtn: (list, enabled) ->
      btn = jQuery '<span></span>'
      img = icon = null
      if (typeof enabled != 'boolean')
        img = enabled
      else
        icon = "icon-list-#{list.toLowerCase()}"
      if list=='ordered'
        lbl = 'numbered_list'
      else if list=='unordered'
        lbl = 'bullet_points'
      btn.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          label: lbl
          command: "insert#{list}List"
          icon: icon
          img: img
          cssClass: @options.buttonCssClass

      btn        

    _makeDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='lists-list ui-droplist'></div>"
      for list, enabled of @options.lists
        continue unless enabled
        btn = @_makeActionBtn(list, enabled)
        contentArea.append btn
      contentArea

    _makeToolbarButton: (target) ->
      btn = jQuery '<span></span>'
      btn.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'lists'
        img: target.children(0).find('img').attr('src')
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      btn


)(jQuery)

