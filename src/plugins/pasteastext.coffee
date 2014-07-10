#     Hallo - a rich text editing jQuery UI widget
#     (c) 2012 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license

#     pasteastext - a plugin for Hallo to force pasted content to be plain text
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#


((jQuery) ->
  jQuery.widget 'IKS.pasteastext',

    _create: ->
      editor = this.element
      editor.bind 'paste', this, (e) =>
        pastedText = ''
        if (window.clipboardData && window.clipboardData.getData) 
          # IE
          pastedText = window.clipboardData.getData('Text')
        else if (e.originalEvent.clipboardData && e.originalEvent.clipboardData.getData) 
          pastedText = e.originalEvent.clipboardData.getData('text/plain')
        document.execCommand 'insertText', false, pastedText
        e.preventDefault()

) jQuery
