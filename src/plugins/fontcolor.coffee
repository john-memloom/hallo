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
      grays: [
        '040404', '333333', '535353', '878787', 'A8A8A8', 'C1C1C1', 'D0D0D0', 'EBEBEB', 'F0F0F0', 'FFFFFF'
      ]
      brights: [
        '761616', 'e12828', 'ec8a28', 'fffa29', '72f507', '69fafa', '4177de', '0029fa', '6f30fb', 'dc3bff'
      ]
      shades: [
        'd6aba2', 'e8c3c2', 'f6dfc4', 'fdeec3', 'd5e3c9', 'c9d8d8', 'c0d2f4', 'c8d8ee', 'cec9e3', 'dfc8d4',    
        'c46f5e', 'd58b8b', 'eec08f', 'fbdd8d', 'b1cb98', '99b6bc', '98b6ee', '95b9e0', 'a099cb', 'c198b0',    
        'ac3b2a', 'c45a5a', 'e7a461', 'f9ce5d', '8fb36b', '6e939d', '618fe2', '6789d0', '756db4', 'a76d90',    
        '842018', 'aa1e1f', 'd18138', 'e5b436', '69933f', '436d79', '3469cb', '3c73b6', '4c4394', '864368',    
        '661e16', '771616', '974f1b', 'aa7d1c', '3c5f17', '1d3d48', '104abd', '17437f', '211c60', '561c39',    
        '41120d', '490e0e', '5d3211', '674d12', '273b10', '13272e', '193872', '102b4f', '14123b', '341225'
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
        colorBlock = jQuery "<div class='font-color-block' style='background-color: \##{color}; border-color: \##{color}'></div>"
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
          @widget.options.editable.element.trigger('hallomodified')
      for sectionName in ['grays', 'brights', 'shades']
        section = jQuery "<div class='font-color-selection' style='height: #{(@options[sectionName].length/10)*17}px;'></div>"
        for color in @options[sectionName]
          section.append addColor(color)
        contentArea.append(section)
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
