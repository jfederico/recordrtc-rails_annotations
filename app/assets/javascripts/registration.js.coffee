$(document).ready ->
  #/////////////////////////////////////////////////////////////////////////////
  # JavaScript for CONTROLLER: registration, global
  #/////////////////////////////////////////////////////////////////////////////

  if $('body').hasClass('registration')
    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: registration, ACTION: register
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('register')
      #//////////////////
      # Helper functions
      #//////////////////

      selectAll ->
        $('input:checkbox').prop 'checked', true
        return

      unselectAll ->
        $('input:checkbox').prop 'checked', false
        return


      #//////////////////
      # Setup
      #//////////////////

      checkAllBtn = document.querySelector('button#checkAll')
      uncheckAllBtn = document.querySelector('button#uncheckAll')


      #//////////////////
      # Event watchers
      #//////////////////

      # Check/uncheck all checkboxes in form
      checkAllBtn.onclick = selectAll
      uncheckAllBtn.onclick = unselectAll
  return
