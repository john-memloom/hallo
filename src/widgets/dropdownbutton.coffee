#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
# updated by John Harding, 2014
# - made offset of target area configurable
# - made it accept either an icon or an image

((jQuery) ->
  jQuery.widget 'IKS.hallodropdownbutton',
    button: null

    options:
      uuid: ''
      label: null
      icon: null
      img: null
      html: null
      editable: null
      target: ''
      targetOffset: { x: -20, y: 0}
      cssClass: null

    _create: ->
      if (@options.html==null && @options.img==null)
        @options.icon ?= "icon-#{@options.label.toLowerCase()}"

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
      if (@options.cssClass=='flat')
        classes = [
          'ui-button-flat'
          'ui-widget'
          'ui-button-text-only'
        ]
      else
        classes = [
          'ui-button'
          'ui-widget'
          'ui-state-default'
          'ui-corner-all'
          'ui-button-text-only'
        ]

      if (@options.icon != null)
        glyph = "<i class=\"#{@options.icon}\"></i>" if @options.icon
      else if (@options.html != null)
        glyph = @options.html
      else
        glyph = "<img src='#{@options.img}'></img>" if @options.img

      dropglyph = "<img src='/svg-icons/textedit_dropdown.svg' class='ui-drop-down-button'></img>"

      buttonEl = jQuery "<button id=\"#{id}\"
       class=\"#{classes.join(' ')}\" title=\"#{@options.label}\">
       <span class=\"ui-button-text\">#{glyph}#{dropglyph}</span>
       </button>"
      buttonEl.addClass @options.cssClass if @options.cssClass
      buttonEl

)(jQuery)
