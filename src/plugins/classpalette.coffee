((jQuery) ->
  jQuery.widget "IKS.classpalette",

    options:
      uuid: ''
      editable: null
      colorClasses: {}

    cssAppliers: {}

    populateToolbar: (toolbar) ->
      widget = this
      buttonset = jQuery "<span class=\"#{widget.widgetName}\"></span>"

      buttonize = (lbl, cls) =>
        buttonHolder = jQuery '<span></span>'
        buttonHolder.hallobutton
          uuid: @options.uuid
          editable: @options.editable
          icon: 'icon-stop'
          cssClass: cls
          label: lbl + ' color'
        buttonset.append buttonHolder
        @cssAppliers[cls] = rangy.createCssClassApplier(cls, {normalize: true})
        buttonHolder.on "click", (event) ->
          r = widget.options.editable.getSelection()
          for x, applier of widget.cssAppliers
            applier.undoToRange(r)
          widget.cssAppliers[cls].applyToRange(r)
          widget.options.editable.restoreSelection r
          widget.options.editable.setModified(true)
          return false

      for lbl, cls of @options.colorClasses
        buttonize lbl, cls

      buttonset.hallobuttonset()
      toolbar.append buttonset
)(jQuery)