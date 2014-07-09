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

      @element.append @button

    _showTarget: ->
      target = jQuery @options.target
      @_updateTargetPosition()
      target.addClass 'open'
      target.show()
    
    _hideTarget: ->
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
      classes = [
        'ui-button'
        'ui-widget'
        'ui-state-default'
        'ui-corner-all'
        'ui-button-text-only'
      ]
      buttonEl = jQuery "<button id=\"#{id}\"
       class=\"#{classes.join(' ')}\" title=\"#{@options.label}\">
       <span class=\"ui-button-text\"><input type='text' size='#{@options.size}' value='#{@options.default}'></input>&nbsp;<i class=\"icon-caret-down\"></i></span>
       </button>"
      buttonEl.addClass @options.cssClass if @options.cssClass
      buttonEl

)(jQuery)
