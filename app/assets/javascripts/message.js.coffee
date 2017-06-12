$(document).ready ->
  #/////////////////////////////////////////////////////////////////////////////
  # JavaScript for CONTROLLER: message, global
  #/////////////////////////////////////////////////////////////////////////////

  if $('body').hasClass('message')
    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: message, ACTION: recordrtc_launch_request
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('recordrtc_launch_request')
      #//////////////////
      # Helper functions
      #//////////////////

      refresh = ->
        $.ajax url: '/recordrtc/refresh_uploads'
        return


      #//////////////////
      # Setup
      #//////////////////

      # Hidden for now
      # refreshBtn = document.querySelector('button#refresh')


      #//////////////////
      # Event watchers
      #//////////////////

      # Hidden for now
      # refreshBtn.onclick = refresh

      setInterval (->
        refresh()
        return
      ), 5000



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: message, ACTION: signed_content_item_form
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('signed_content_item_form')
      #//////////////////
      # Helper functions
      #//////////////////

      submitForm = ->
        paramsForm.submit()
        return


      #//////////////////
      # Setup
      #//////////////////

      paramsForm = document.querySelector('form#lti_form')


      #//////////////////
      # Main logic
      #//////////////////

      submitForm()
  return
