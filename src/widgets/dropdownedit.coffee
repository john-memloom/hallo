#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     hallodropdownedit - a widget for Hallo to allow a drop down edit in the toolbar
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget 'IKS.hallodropdownedit',
    button: null

    options:
      uuid: ''
      label: null
      editable: null
      target: ''
      targetOffset: { x: -20, y: 0}
      cssClass: null
      default: null
      size: 10
      change: null

    _init: ->
      target = jQuery @options.target
      target.css 'position', 'absolute'
      target.addClass 'dropdown-menu'

      target.hide()
      @button = @_prepareButton() unless @button

      @button.on 'click', =>
        if target.hasClass 'open'
          @_hideTarget()
          return
        @_showTarget()

      target.on 'click', =>
        @_hideTarget()

      @options.editable.element.on 'hallodeactivated', =>
        @_hideTarget()

      @options.editable.element.on 'hallodropdownhidden', (evt) =>
        evt.stopPropagation()
        if (evt.originalEvent)
          trgt = $(evt.originalEvent.currentTarget.parentElement).find('.dropdown-menu')[0]
        @_hideTarget() unless @options.target[0] == trgt

      @element.append @button

    _activateEditField: (active) ->
      console.log('activatefield', active)
      id = "#{@options.uuid}-#{@options.label}"
      inp = $('#' + id + ' input')
      inp.attr('readonly', if active==true then null else true)
      if (active)
        @options.editable.cachedSelection = @options.editable.getSelection()
        @options.editable.keepActivated true
        inp.focus()
      else
        @options.editable.keepActivated false
        @options.editable.element.focus()
        @options.editable.restoreSelection(@options.editable.cachedSelection) if @options.editable.cachedSelection

    _showTarget: ->
      @_activateEditField(true)
      target = jQuery @options.target
      @_updateTargetPosition()
      target.addClass 'open'
      target.show()
    
    _hideTarget: ->
      @_activateEditField(false)
      target = jQuery @options.target
      target.removeClass 'open'
      target.hide()

    _updateTargetPosition: ->
      target = jQuery @options.target
      {top, left} = @button.position()
      top += @button.outerHeight()
      target.css 'top', top + @options.targetOffset.y
      target.css 'left', left + @options.targetOffset.x

    _prepareButton: ->
      id = "#{@options.uuid}-#{@options.label}"
      if (@options.cssClass=='flat')
        classes = [
          'ui-button-flat'
          'ui-widget'
          'ui-button-text-only'
        ]
        dropglyph = @options.editable.options.dropglyph
        if (dropglyph)
          dropglyph =  "<img src='#{dropglyph}' class='ui-drop-down-button'></img>"
        else
          dropglyph =  "<img src='/svg-icons/textedit_dropdown.svg' class='ui-drop-down-button'></img>"
      else
        classes = [
          'ui-button'
          'ui-widget'
          'ui-state-default'
          'ui-corner-all'
          'ui-button-text-only'
        ] 
        dropglyph = "<i class='icon-caret-down' style='float: right;'></i>"
      buttonEl = jQuery "<button id=\"#{id}\"
       class=\"#{classes.join(' ')}\" title=\"#{@options.label.replace(/_/g, ' ')}\">
       <div style='float: left;'>
       <input readonly type='text' size='#{@options.size}' value='#{@options.default}'></input>&nbsp;
       </div>
       #{dropglyph}
       </button>"
      buttonEl.addClass @options.cssClass if @options.cssClass
      if @options.change
        setTimeout =>
          inp = $('#' + id + ' input')
          inp.on 'change', =>
            inp = $('#' + id + ' input')
            @options.change inp.val(), @options.editable
            @_hideTarget()
        , 300



      buttonEl

)(jQuery)
