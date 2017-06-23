'use strict'

# Only start executing once DOM has loaded
$(document).on 'turbolinks:load', ->
  #/////////////////////////////////////////////////////////////////////////////
  # JavaScript for CONTROLLER: record, global
  #/////////////////////////////////////////////////////////////////////////////

  if $('body').hasClass 'record'
    #//////////////////
    # Helper functions
    #//////////////////

    # Check to see if title and description are not empty, and display alert if so
    validate = ->
      if titleInput.val() is '' and descriptionInput.val() is ''
        titleInput.parent().addClass 'has-error'
        descriptionInput.parent().addClass 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The title and description can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else if titleInput.val() is ''
        titleInput.parent().addClass 'has-error'
        descriptionInput.parent().removeClass 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The title can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else if descriptionInput.val() is ''
        titleInput.parent().removeClass 'has-error'
        descriptionInput.parent().addClass 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The description can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else
        titleInput.parent().removeClass('has-error').addClass 'has-success'
        descriptionInput.parent().removeClass('has-error').addClass 'has-success'
        true


    #//////////////////
    # Setup
    #//////////////////

    # Customize SweetAlert2 dialog
    window.sweetAlertConfirmConfig =
      title: 'Are you sure?'
      text: 'You will not be able to recover this recording!'
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Delete'
      cancelButtonText: 'Cancel'



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: record, ACTION: index
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass 'index'
      #//////////////////
      # Helper functions
      #//////////////////

      refresh = ->
        $.ajax url: 'refresh_recordings'
        return


      #//////////////////
      # Setup
      #//////////////////

      closeCompatibilityAlert = $('#close-alert')
      deleteBtn = $('a.delete-btn')
      closeTool = $('a#close')

      browserSupported = bowser.firefox and bowser.version >= 29 or
                         bowser.chrome and bowser.version >= 49 or
                         bowser.opera and bowser.version >= 36

      # Customize DataTables table of all recordings on launch page
      table = $('#recordings-table').dataTable(
        'stateSave': true,
        'columnDefs': [
          {
            'targets': 2
            'orderable': false
            'searchable': false
          }
        ]
      )


      #//////////////////
      # Event watchers
      #//////////////////

      # Refresh recordings partial when delete button is clicked
      deleteBtn.on 'ajax:success', ->
        refresh()
        return

      # Close LTI tool tab
      closeTool.click ->
        window.close()
        return


      #//////////////////
      # Main logic
      #//////////////////

      # Auto-close browser compatibility alert if browser is well-supported
      if browserSupported
        closeCompatibilityAlert.click()



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: record, ACTION: new
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass 'new'
      #//////////////////
      # Helper functions
      #//////////////////

      handleSourceOpen = (event) ->
        console.log 'MediaSource opened'
        `sourceBuffer = mediaSource.addSourceBuffer('video/webm; codecs="vp8"')`
        console.log 'Source buffer: ', sourceBuffer
        return

      successCallback = (stream) ->
        console.log 'getUserMedia() got stream: ', stream
        # Make stream globally accessible
        window.stream = stream

        # Set video player to display webcam stream
        if window.URL
          videoPlayer.prop 'srcObject', window.stream
        else
          videoPlayer.prop 'srcObject', stream
        return

      errorCallback = (error) ->
        console.log 'getUserMedia() error: ', error
        return

      handleDataAvailable = (event) ->
        # Add latest chunk to array of recorded chunks
        recordedChunks.push event.data
        return

      handleStop = (event) ->
        console.log 'Recorder stopped: ', event
        return

      toggleRecording = ->
        if startStopBtn.html() is '<i class="fa fa-circle"></i> Start Recording' or startStopBtn.html() is '<i class="fa fa-circle"></i> Record Again'
          startRecording()

          startStopBtn.removeClass 'btn-outline'
          titleInput.parent().removeClass 'has-error'
          descriptionInput.parent().removeClass 'has-error'
        else
          stopRecording()

          startStopBtn.addClass 'btn-outline'
          startStopBtn.html '<i class="fa fa-circle"></i> Record Again'
        return

      startRecording = ->
        # Reset array of recorded chunks
        `recordedChunks = []`

        # Disable controls and mute video player
        videoPlayer.prop 'controls', false
        videoPlayer.prop 'muted', true

        # Make video player display webcam stream again (for when 'Record Again' is clicked)
        if window.URL
          videoPlayer.prop 'srcObject', window.stream
        else
          videoPlayer.prop 'srcObject', stream

        # Hide upload form if not already hidden
        uploadForm.css 'display', 'none'

        `mediaRecorder = new MediaRecorder(window.stream)`
        console.log 'Created MediaRecorder', mediaRecorder

        # Begin recording countdown timer
        startStopBtn.html '<i class="fa fa-stop-circle"></i> Stop Recording (<span id="minutes">02</span>:<span id="seconds">00</span>)'
        `countdownSeconds = 120`
        `countdownTicker = setInterval(function () {
          setTime();
        }, 1000)`

        mediaRecorder.onstop = handleStop
        mediaRecorder.ondataavailable = handleDataAvailable
        mediaRecorder.start 10 # Collect data every 10ms

        console.log 'MediaRecorder started', mediaRecorder
        return

      stopRecording = ->
        # Clear the countdown timer
        clearInterval countdownTicker

        # Disable "Record Again" button for 1s to allow background processing (closing streams)
        setTimeout ->
          startStopBtn.prop 'disabled', false
          return
        , 1000

        mediaRecorder.stop()

        `blob = new Blob(recordedChunks, { type: 'video/webm' })`
        # Set video player to play final recording, in true video player style
        videoPlayer.prop 'src', window.URL.createObjectURL blob
        videoPlayer.prop 'controls', true
        videoPlayer.prop 'muted', false

        # Unhide upload form
        uploadForm.css 'display', 'initial'
        return

      upload = ->
        # Generate unique filename
        date = (new Date).valueOf().toString()
        id = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
        fileName = date + '-' + id + '.webm'

        # Make form data using user input from form
        formData = new FormData
        formData.append 'recording[title]', titleInput.val()
        formData.append 'recording[description]', descriptionInput.val()
        formData.append 'recording[video]', blob, fileName
        formData.append 'recording[account_id]', accountInput.val()

        # Upload the form data
        makeXMLHttpRequest '/api/recordings', 'POST', formData
        return

      makeXMLHttpRequest = (url, method, data) ->
        xhr = new XMLHttpRequest

        xhr.onreadystatechange = ->
          console.log 'Response:', xhr.responseText
          return

        xhr.upload.onloadstart = ->
          console.log 'Upload started'

          # Disable recording button
          startStopBtn.prop 'disabled', true

          # Transform upload button to show progress
          progressBtn.ladda 'start'
          return

        xhr.upload.onprogress = (event) ->
          if event.lengthComputable
            console.log 'Upload progress:', parseInt(event.loaded / event.total * 100) + '%'

            # Update progress of upload button
            progressBtn.ladda 'setProgress', (event.loaded / event.total)
          return

        xhr.upload.onload = ->
          console.log 'Upload ended'

          # Make upload button return to normal
          progressBtn.ladda 'stop'

          # Open success modal
          modalBtn.click()
          return

        xhr.upload.onerror = (error) ->
          console.log 'Failed to upload to server'
          console.error 'XMLHttpRequest failed:', error
          return

        xhr.upload.onabort = (error) ->
          console.log 'Upload aborted'
          console.error 'XMLHttpRequest aborted:', error
          return

        xhr.open method, url
        xhr.send data
        return

      # Makes 1min and 2s display as 1:02 on timer instead of 1:2, for example
      pad = (val) ->
        valString = val + ''

        if valString.length < 2
          '0' + valString
        else
          valString

      # Functionality to make recording timer count down
      # Also makes recording stop when time limit is hit
      setTime = ->
        countdownSeconds--

        startStopBtn.children('span#seconds').html pad(countdownSeconds % 60)
        startStopBtn.children('span#minutes').html pad(parseInt(countdownSeconds / 60))

        if countdownSeconds is 0
          startStopBtn.click()
        return


      #//////////////////
      # Setup
      #//////////////////

      # Initialize MediaSource connection (not sure what it does, but it's important)
      mediaSource = new MediaSource
      mediaSource.addEventListener 'sourceopen', handleSourceOpen, false
      sourceBuffer = null

      # Initialize variables for recording stream
      mediaRecorder = null
      recordedChunks = null
      blob = null

      # Initialize variables for countdown timer
      countdownSeconds = null
      countdownTicker = null

      # Create names for important HTML elements
      videoPlayer = $('video#video-player')
      startStopBtn = $('button#start-stop')
      uploadForm = $('div#upload-form')
      titleInput = uploadForm.find 'input#title'
      descriptionInput = uploadForm.find 'textarea#description'
      accountInput = uploadForm.children 'input#account_id'
      uploadBtn = uploadForm.children 'button#upload'
      progressBtn = uploadBtn.ladda()
      goBack = $('a#back')
      modal = $('#updated-alert')
      modalBtn = $('button#show-modal')

      # To make sure connection is secure
      isSecureOrigin = location.protocol is 'https' or _.includes location.host, 'localhost'

      # Record both audio and video
      constraints =
        audio: true
        video: true


      #//////////////////
      # Event watchers
      #//////////////////

      startStopBtn.click ->
        toggleRecording()
        return

      # Validate form before sending it off to server
      uploadBtn.click ->
        if validate()
          upload()
        return

      # Close tab when success modal is closed
      modal.on 'hidden.bs.modal', ->
        goBack[0].click()
        return


      #//////////////////
      # Main logic
      #//////////////////

      # Start form off hidden
      uploadForm.css 'display', 'none'

      # Show error alert if not launched over HTTPS
      if !isSecureOrigin
        swal(
          title: 'Content insecure'
          text: 'This tool must be run from a secure origin: HTTPS or localhost.'
          type: 'error'
          confirmButtonText: 'Take me back'
        ).then ->
          window.close()
          return

      # Commence capturing of webcam stream
      navigator.mediaDevices.getUserMedia(constraints).then(successCallback).catch(errorCallback)



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: record, ACTION: edit
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass 'edit'
      #//////////////////
      # Setup
      #//////////////////

      editForm = $('form')
      titleInput = editForm.find 'input#recording_title'
      descriptionInput = editForm.find 'textarea#recording_description'
      goBack = $('a#back')
      modal = $('#updated-alert')
      modalBtn = $('button#show-modal')


      #//////////////////
      # Event watchers
      #//////////////////

      # Validate form before sending it off to server
      editForm.on 'submit', ->
        return validate()

      # Open success modal on succesful form submission
      editForm.on 'ajax:success', ->
        modalBtn.click()
        return

      # Close tab when success modal is closed
      modal.on 'hidden.bs.modal', ->
        goBack[0].click()
        return



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: record, ACTION: show
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass 'show'
      #//////////////////
      # Setup
      #//////////////////

      deleteBtn = $('a#delete-btn')
      goBack = $('a#back')


      #//////////////////
      # Event watchers
      #//////////////////

      # Open success modal on succesful form submission
      deleteBtn.on 'ajax:success', ->
        goBack[0].click()
        return
  return
