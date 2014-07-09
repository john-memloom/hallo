#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     fontcolor - a plugin for Hallo to allow user to choose from a grid of colors
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 

((jQuery) ->
  jQuery.widget 'IKS.fontcolor',
    options:
      editable: null
      toolbar: null
      uuid: ''
      colors: [
        'ffffff','ffccc9','ffce93','fffc9e','ffffc7','9aff99','96fffb','cdffff',
        'cbcefb','cfcfcf','fd6864','fe996b','fffe65','fcff2f','67fd9a','38fff8',
        '68fdff','9698ed','c0c0c0','fe0000','f8a102','ffcc67','f8ff00','34ff34',
        '68cbd0','34cdf9','6665cd','9b9b9b','cb0000','f56b00','ffcb2f','ffc702',
        '32cb00','00d2cb','3166ff','6434fc','656565','9a0000','ce6301','cd9934',
        '999903','009901','329a9d','3531ff','6200c9','343434','680100','963400',
        '986536','646809','036400','34696d','00009b','303498','000000','330001',
        '643403','663234','343300','013300','003532','010066','340096',        
      ]
      buttonCssClass: null

    populateToolbar: (toolbar) ->
      @widget = this
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target

    _prepareDropdown: (contentId) ->
      contentArea = jQuery "<div id='#{contentId}' class='font-color-picker'></div>"
      addColor = (color) => 
        colorBlock = jQuery "<div class='font-color-block' style='background-color: \##{color};'></div>"
        colorBlock.on "click", =>
          color = colorBlock.css('background-color')
          el = @widget.options.editable.element
          r = @widget.options.editable.getSelection()
          allOrNothing = (r.toString()=='' || (r.toString().trim() == el.text().trim()))
          if (allOrNothing)              
            el.children().css('color', '')
            el.css('color', color)
          else
            rangy.createStyleApplier("color: #{color};", {normalize: true}).applyToRange(r)
      for color in @options.colors
        contentArea.append addColor(color)
      contentArea

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: 'fonts'
        img: 'colors.gif'
        target: target
        targetOffset: {x:0, y:0}
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
