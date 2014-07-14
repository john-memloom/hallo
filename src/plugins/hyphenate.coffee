#     Hallo - a rich text editing jQuery UI widget
#     (c) 2012 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license

#     hyphenate - a plugin for Hallo to integrate jquery.hypher which automatically hyphonates words
#     (c) 2014 John Harding, Memloom, inc.
#     plugin may be freely distributed with Hallo.js utilizing same license as Hallo.js 
#

((jQuery) ->
  jQuery.widget 'IKS.hyphenate',

    _create: ->
      editor = this.element
      # editor.hyphenate('en-us')
      editor.bind 'hallomodified', this, (e) =>
        # els = $(editor).find('*')
        # els.hyphenate('en-us')
        editor.hyphenate('en-us');
        false

) jQuery
