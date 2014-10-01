#     Hallo - a rich text editing jQuery UI widget
#     (c) 2012 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license

#     deleteall - a plugin for Hallo to empty out all structure when the user delets all text
#     and replace it with a div with the given style
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#

((jQuery) ->
  jQuery.widget 'IKS.deleteall',
    options:
      default_styles: ''

    _create: ->
      widget = this
      widget.element.bind 'hallomodified', this, (e) =>
        if widget.element.text().trim() == ''
          widget.element.children().remove()
          widget.element.append("<div style='" + widget.options.default_styles + "'></div>")
          node = widget.element.children().first()[0]
          range = rangy.createRange();
          range.setStartAfter(node)
          range.setEndAfter(node)
          sel = rangy.getSelection()
          sel.removeAllRanges()
          sel.addRange(range)

) jQuery
