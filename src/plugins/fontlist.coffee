#     fontlist - a plugin for Hallo to allow user to choose from list of fonts
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget 'IKS.fontlist',
    options:
      editable: null
      toolbar: null
      uuid: ''
      buttonCssClass: null

      # fonts[] can contain strings representing font-families, the string '-' will insert
      # a <hr> in the div that lists the available fonts
      fonts: [
       'Arial'
       'Times'
       'Verdana'
      ]

      # alternatively, fonts[] can contain an object of the following structure
      #   {
      #     fontId: user_defined_string, 
      #     fontName: what_to_display_in_control, 
      #     sampleIMG: path_to_img_containing_sample_text_displayed_in_drop_down 
      #   }
      # in the latter case provide fontCallback: pointing to a function that takes the fontId and returns the font-family.  
      # The intent of the callback is to allow the host application to load the font only when used.
      #
      # fonts: [
      #   {fontId: 'wckqr123', fontName: 'fancy font 1', sampleIMG: 'fancy_font_1_sample.png'}
      #   {fontId: 'asdf344',  fontName: 'fancy font 2', sampleIMG: 'fancy_font_2_sample.png'}
      # ]
      # fontCallback: loadTypeKitFont
      # 
      # fonts[] can also contain a mix of font-family strings and objects
      #
      # fonts[] entries that start with a . are considered a class name followed by unclickable content
      #
      # Putting it altogether:
      #
      #   fonts: [
      #     '.menu_heading System Fonts'
      #     'Arial'
      #     'Times'
      #     'Verdana'
      #     '-'
      #     '.menu_heading Typekit Fonts'
      #     {fontId: 'wckqr123', fontName: 'fancy font 1', sampleIMG: 'fancy_font_1_sample.png'}
      #     {fontId: 'asdf344',  fontName: 'fancy font 2', sampleIMG: 'fancy_font_2_sample.png'}
      #   ]

    populateToolbar: (toolbar) ->
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target
      @_prepareQueryState()

    _prepareQueryState: ->
      queryState = (event) =>
        r = @widget.options.editable.getSelection()
        font = getComputedStyle(r.startContainer.parentElement).getPropertyValue('font-family')
        $('#' + @widget.options.uuid + '-fonts span').text(font)
      events = 'keyup paste change hallomodified mouseup'
      @options.editable.element.on events, queryState
      @options.editable.element.on 'halloenabled', =>
        @options.editable.element.on events, queryState
      @options.editable.element.on 'hallodisabled', =>
        @options.editable.element.off events, queryState

    _prepareDropdown: (contentId) ->

      applyFont = (font, name) =>
        el = @widget.options.editable.element
        r = @widget.options.editable.getSelection()
        allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
        if (allOrNothing)              
          el.children().css('font-family', '')
          el.css('font-family', font)
        else
          rangy.createStyleApplier("font-family: #{font};", {normalize: true}).applyToRange(r)
        $('#' + @widget.options.uuid + '-fonts span').text(name)
        @widget.options.editable.element.trigger('hallomodified')

      addFont = (font) =>
        fntBtn = jQuery "<div class='font-item' style='font-family: #{font};'>#{font}</div>"
        fntBtn.on 'click', => 
          font = fntBtn.text()
          applyFont(font, font)
        fntBtn

      addCallback = (obj) =>
        fntBtn = jQuery "<div class='font-item'><img src='#{obj.sampleIMG}'/></img></div>"
        fntBtn.on 'click', => 
          font = @widget.options.fontCallback(obj.fontId)
          applyFont(font, obj.fontName)
        fntBtn

      contentArea = jQuery "<div id='#{contentId}' class='font-list'></div>"
      for font in @options.fonts
        console.log(font)
        if typeof font=='string'
          if font == '-'
            contentArea.append('<hr />')
          else if font[0] == '.'
            klass = font.split(' ')[0].substring(1, 999)
            txt = font.substring(font.indexOf(' ')+1, 999)
            heading = jQuery('<div></div>').text(txt).addClass(klass)
            contentArea.append(heading)
          else
            contentArea.append (addFont(font))
        else
          contentArea.append (addCallback(font))
      console.log(contentArea.html())
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdowntext
        uuid: @options.uuid
        editable: @options.editable
        label: 'fonts'
        default: 'Times'
        target: target
        targetOffset: {x:0, y:0}
        width: 100
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
