#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget 'IKS.hallobutton',
    button: null
    isChecked: false

    options:
      uuid: ''
      label: null
      icon: null
      img: null
      html: null
      editable: null
      command: null
      commandValue: null
      queryState: true
      cssClass: null

    _create: ->
      # By default the icon is icon-command, but this doesn't
      # always match with
      # <http://fortawesome.github.com/Font-Awesome/#base-icons>
      if @options.img == null && @options.html == null
        @options.icon ?= "icon-#{@options.label.toLowerCase()}" 

      id = "#{@options.uuid}-#{@options.label}"
      opts = @options
      @button = @_createButton id, opts.command, opts.label, opts.icon, opts.img, opts.html, opts.cssClass == 'flat'
      @element.append @button
      @button.addClass @options.cssClass if @options.cssClass unless @options.cssClass=='flat'
      @button.addClass 'btn-large' if @options.editable.options.touchScreen
      @button.data 'hallo-command', @options.command
      if @options.commandValue
        @button.data 'hallo-command-value', @options.commandValue
      if @options.img != null
        @button.img = @options.img if (typeof @options.img == 'object')
        
      hoverclass = 'ui-state-hover'
      @button.on 'mouseenter', (event) =>
        if @isEnabled()
          @button.addClass hoverclass
      @button.on 'mouseleave', (event) =>
        @button.removeClass hoverclass

    _init: ->
      @button = @_prepareButton() unless @button
      @element.append @button

      if @options.queryState is true
        queryState = (event) =>
          return unless @options.command
          try
            if @options.commandValue
              value = document.queryCommandValue @options.command
              compared = value.match(new RegExp(@options.commandValue,"i"))
              @checked(if compared then true else false)
            else
              @checked document.queryCommandState @options.command
          catch e
            return
      else
        queryState = @options.queryState

      if @options.command
        @button.on 'click', (event) =>
          if @options.commandValue
            @options.editable.execute @options.command, @options.commandValue
          else
            @options.editable.execute @options.command
          if typeof queryState is 'function'
            queryState()
          return false

      return unless @options.queryState

      editableElement = @options.editable.element
      events = 'keyup paste change mouseup hallomodified'
      editableElement.on events, queryState
      editableElement.on 'halloenabled', =>
        editableElement.on events, queryState
      editableElement.on 'hallodisabled', =>
        editableElement.off events, queryState

    enable: ->
      @button.removeAttr 'disabled'

    disable: ->
      @button.attr 'disabled', 'true'

    isEnabled: ->
      return @button.attr('disabled') != 'true'

    refresh: ->
      if @isChecked
        @button.addClass 'ui-state-active'
        if @button.img
          @button.find('img').attr('src', @button.img[1])
      else
        @button.removeClass 'ui-state-active'
        if @button.img
          @button.find('img').attr('src', @button.img[0])

    checked: (checked) ->
      @isChecked = checked
      @refresh()

    _createButton: (id, command, label, icon, img, html, flat) ->
      if (flat)
        classes = [
          'ui-button-flat'
          'ui-widget'
          'ui-button-text-only'
          "#{command}_button"
        ]
      else
        classes = [
          'ui-button'
          'ui-widget'
          'ui-state-default'
          'ui-corner-all'
          'ui-button-text-only'
          "#{command}_button"
        ]
      if (icon!=null)
        glyph = "<i class=\"#{icon}\"></i>"
      else if (html != null)
        glyph = html
      else
        if typeof img == 'string'
          glyph = "<img src=\"#{img}\"></img>"
        else
          glyph = "<img src=\"#{img[0]}\"></img>"

      jQuery "<button id=\"#{id}\"
        class=\"#{classes.join(' ')}\" title=\"#{label.replace(/_/g, ' ')}\">
          <span class=\"ui-button-text\">
            #{glyph}
          </span>
        </button>"

  jQuery.widget 'IKS.hallobuttonset',
    buttons: null
    _create: ->
      @element.addClass 'ui-buttonset'

    _init: ->
      @refresh()

    refresh: ->
      rtl = @element.css('direction') == 'rtl'
      @buttons = @element.find '.ui-button'
      @buttons.removeClass 'ui-corner-all ui-corner-left ui-corner-right'
      if rtl
        @buttons.filter(':first').addClass 'ui-corner-right'
        @buttons.filter(':last').addClass 'ui-corner-left'
      else
        @buttons.filter(':first').addClass 'ui-corner-left'
        @buttons.filter(':last').addClass 'ui-corner-right'
)(jQuery)
