$(document).ready ->
  #/////////////////////////////////////////////////////////////////////////////
  # JavaScript for CONTROLLER: registration, global
  #/////////////////////////////////////////////////////////////////////////////

  if $('body').hasClass 'registration'
    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: registration, ACTION: register
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass 'register'
      #//////////////////
      # Helper functions
      #//////////////////

      checkAll = ->
        checkboxes.prop('checked', true)
        return

      uncheckAll = ->
        checkboxes.prop('checked', false)
        return


      #//////////////////
      # Setup
      #//////////////////

      checkboxes = $('input:checkbox')
      checkAllBtn = $('button#check-all')
      uncheckAllBtn = $('button#uncheck-all')


      #//////////////////
      # Event watchers
      #//////////////////

      checkAllBtn.click ->
        checkAll()
        return

      uncheckAllBtn.click ->
        uncheckAll()
        return
  return
