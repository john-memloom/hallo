#
#     fontautosize - a plugin for Hallo to allow user to fit the text to the max size and still
#     fit in the container
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

# keep selection after autoszie complete


((jQuery) ->
  jQuery.widget "IKS.fontautosize",

    options:
      uuid: ''
      editable: null
      icon: null
      img: null

    autoSizeButton: null

    populateToolbar: (toolbar) ->
      widget = this

      _autoSize = () ->

        el = widget.options.editable.element
        columns = parseInt(el.css('column-count')) || 1
        if columns > 1
          originalWidth = el.width()
          originalHeight = el.height()
          # el.css('column-count', "1 !important") 
          if (el.hasClass('two-columns'))
            el.removeClass('two-columns')
            columnClass = 'two-columns'
            ff = 0
          else if (el.hasClass('three-columns'))
            el.removeClass('three-columns')
            columnClass = 'three-columns'
            ff = 50
          else
            console.log("UNKNOWN COLUMN CLASS...")
          el.css('height', el.height() * columns)
          el.css('width', (el.width() / columns)-ff)


        divsWithTableCell = el.find('*').filter (idx,el) => $(el).css('display') == 'table-cell'
        if divsWithTableCell.length > 0
          divsWithTableCell.css('display', 'block')
          el.css('display', 'block')
          # el.hide()
          # el[0].offsetHeight = el[0].offsetHeight;  
          # el.show()
          # divsWithTableCell.contents().unwrap()

        sz = px2num(el.css('font-size'))
        originalSize = sz
        # note the use of style.fontSize because $().css get's the computed style
        children = el.find('*').filter (idx,el) => $(el)[0].style.fontSize != '' 
        children_sz = []
        original_sz = []
        children.each (idx,el) => 
          children_sz[idx] = px2num($(el).css('font-size')) 
          original_sz[idx] = children_sz[idx]

        if (el.text().trim() == '')
          el.css('font-size', "#{el.height()}px")
        else
          safeguard = 500

          # ramp up until it's too big
          while ((safeguard-- > 0) && (el[0].scrollHeight <= el.height()))
            el.css('font-size', "#{++sz}px")
            children.each (idx,el) => $(el).css('font-size', "#{++children_sz[idx]}px")

          # console.log ("sg = " + safeguard)
          # console.log (">>>> scroll Height " + el[0].scrollHeight)
          # console.log (">>>> Height " + el.height())
          # console.log (">>>> " + el[0].scrollHeight <= el.height())

          # then come back down until it fits
          while (safeguard-- > 0 && el[0].scrollHeight > el.height())
            el.css('font-size', "#{--sz}px")
            children.each (idx,el) => $(el).css('font-size', "#{--children_sz[idx]}px")

          if (safeguard <= 0)
            console.log("SAFEGUARD TRIPPED!") 
            el.css('font-size', "#{originalSize}px")
            children.each (idx,el) => $(el).css('font-size', "#{original_sz[idx]}px")

          if columns > 1
            # el.css('column-count', columns)
            el.addClass(columnClass)
            el.height(originalHeight)
            el.css('width', originalWidth)

        if divsWithTableCell.length > 0
          divsWithTableCell.css('display', 'table-cell')
          el.css('display', 'table')


      @autoSizeButton = jQuery '<span></span>'

      img = icon = null
      img = @options.img
      icon = @options.icon || 'icon-fullscreen' unless img
      @autoSizeButton.hallobutton
            uuid: @options.uuid
            editable: @options.editable
            label: 'automatically size the text'
            icon: icon
            img: img
            cssClass: @options.buttonCssClass

      # to do - shouldn't need to handle ui update here - figure out why hallobutton
      # isn't doing this automagically...
      refresh = () ->
        if isActive() then i = 1 else i = 0
        widget.autoSizeButton.find('img').attr('src', widget.options.img[i])

      isActive = () ->
        widget.autoSizeButton.children().hasClass('ui-state-active')

      @autoSizeButton.on "click", (event) ->
        widget.autoSizeButton.children().toggleClass('ui-state-active')
        refresh()
        if (isActive())
          _autoSize() 
          widget.options.editable.element.trigger('hallomodified', {triggeredBy: 'fontautosize'})

      @options.editable.element.on "hallomodified", (event, data) ->
        if (data && data.triggeredBy == 'fontsize' && isActive())
          widget.autoSizeButton.children().removeClass('ui-state-active')
          refresh()
        _autoSize() if isActive()


      buttonset = jQuery "<span class=\"#{widget.widgetName}\"></span>"
      buttonset.append(@autoSizeButton)
      buttonset.hallobuttonset()
      toolbar.append buttonset

)(jQuery)