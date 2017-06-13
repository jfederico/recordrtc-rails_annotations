'use strict'

# Only start executing once DOM has loaded
$(document).ready ->
  #/////////////////////////////////////////////////////////////////////////////
  # JavaScript for CONTROLLER: recordrtc, global
  #/////////////////////////////////////////////////////////////////////////////

  if $('body').hasClass('recordrtc')
    #//////////////////
    # Helper functions
    #//////////////////

    validate = ->
      if titleInput.value is '' and descriptionInput.value is ''
        titleInput.parentElement.classList.add 'has-error'
        descriptionInput.parentElement.classList.add 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The title and description can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else if titleInput.value is ''
        descriptionInput.parentElement.classList.remove 'has-error'
        titleInput.parentElement.classList.add 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The title can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else if descriptionInput.value is ''
        titleInput.parentElement.classList.remove 'has-error'
        descriptionInput.parentElement.classList.add 'has-error'
        swal(
          title: 'Something\'s missing...'
          text: 'The description can\'t be empty!'
          type: 'warning'
          confirmButtonColor: '#DD6B55'
          confirmButtonText: 'OK'
        )
        false
      else
        titleInput.parentElement.classList.remove 'has-error'
        descriptionInput.parentElement.classList.remove 'has-error'
        titleInput.parentElement.classList.add 'has-success'
        descriptionInput.parentElement.classList.add 'has-success'
        true

    exit = ->
      window.close()
      return


    #//////////////////
    # Setup
    #//////////////////

    closePage = document.querySelector('a#back')


    #//////////////////
    # Event watchers
    #//////////////////

    # Close this tab when 'Close' link is closed
    closePage.onclick = exit



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: recordrtc, ACTION: new
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('new')
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
          videoPlayer.src = window.URL.createObjectURL(stream)
        else
          videoPlayer.src = stream
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
        if startStopBtn.innerHTML is '<i class="fa fa-circle"></i> Start Recording' or startStopBtn.innerHTML is '<i class="fa fa-circle"></i> Record Again'
          startRecording()

          startStopBtn.classList.remove 'btn-outline'
          startStopBtn.classList.add 'btn-sm'
        else
          stopRecording()

          startStopBtn.classList.add 'btn-outline'
          startStopBtn.innerHTML = '<i class="fa fa-circle"></i> Record Again'
        return

      startRecording = ->
        # Reset array of recorded chunks
        `recordedChunks = []`

        # Disable controls and mute video player
        videoPlayer.controls = false
        videoPlayer.muted = true

        # Make video player display webcam stream again (for when 'Record Again' is clicked)
        if window.URL
          videoPlayer.src = window.URL.createObjectURL(stream)
        else
          videoPlayer.src = stream

        # Hide upload form if not already hidden
        uploadForm.style.display = 'none'

        `mediaRecorder = new MediaRecorder(window.stream)`
        console.log 'Created MediaRecorder', mediaRecorder

        # Begin recording countdown timer
        startStopBtn.innerHTML = '<i class="fa fa-stop-circle"></i> Stop Recording (<label id="minutes">02</label>:<label id="seconds">00</label>)'
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
        setTimeout (->
          startStopBtn.disabled = false
          return
        ), 1000

        mediaRecorder.stop()

        `blob = new Blob(recordedChunks, { type: 'video/webm' })`
        # Set video player to play final recording, in true video player style
        videoPlayer.src = window.URL.createObjectURL(blob)
        videoPlayer.controls = true
        videoPlayer.muted = false

        # Unhide upload form
        uploadForm.style.display = 'initial'
        return

      upload = ->
        # Generate unique filename
        date = (new Date).valueOf().toString()
        id = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
        fileName = date + '-' + id + '.webm'

        # Make form data using user input from form
        formData = new FormData
        formData.append 'upload[title]', titleInput.value
        formData.append 'upload[description]', descriptionInput.value
        formData.append 'upload[video]', blob, fileName

        # Upload the form data
        makeXMLHttpRequest Routes.api_uploads_path(), 'POST', formData
        return

      makeXMLHttpRequest = (url, method, data) ->
        xhr = new XMLHttpRequest

        xhr.onreadystatechange = ->
          console.log 'Response:', xhr.responseText
          return

        xhr.upload.onloadstart = ->
          console.log 'Upload started'

          # Disable recording button
          startStopBtn.disabled = true

          # Transform upload button to show progress
          progressBtn.ladda('start')
          return

        xhr.upload.onprogress = (event) ->
          if event.lengthComputable
            console.log 'Upload progress:', parseInt(event.loaded / event.total * 100) + '%'

            # Update progress of upload button
            progressBtn.ladda('setProgress', (event.loaded / event.total))
          return

        xhr.upload.onload = ->
          console.log 'Upload ended'

          # Make upload button return to normal
          progressBtn.ladda('stop')

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

        startStopBtn.querySelector('label#seconds').innerHTML = pad(countdownSeconds % 60)
        startStopBtn.querySelector('label#minutes').innerHTML = pad(parseInt(countdownSeconds / 60))

        if `countdownSeconds == 0`
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
      videoPlayer = document.querySelector('video#video-player')
      startStopBtn = document.querySelector('button#start-stop')
      uploadForm = document.querySelector('div#upload-form')
      titleInput = uploadForm.querySelector('input#title')
      descriptionInput = uploadForm.querySelector('input#description')
      uploadBtn = uploadForm.querySelector('button#upload')
      progressBtn = $('button#upload').ladda()
      modalBtn = document.querySelector('button#show-modal')

      # To make sure connection is secure
      #var isSecureOrigin = location.protocol === 'https:' ||
      #    location.host === 'localhost';
      #if (!isSecureOrigin) {
      #    alert('getUserMedia() must be run from a secure origin: HTTPS or localhost.' +
      #        '\n\nChanging protocol to HTTPS');
      #    location.protocol = 'HTTPS';
      #}

      # Record both audio and video
      constraints =
        audio: true
        video: true


      #//////////////////
      # Event watchers
      #//////////////////

      startStopBtn.onclick = toggleRecording

      # Validate form before sending it off to server
      uploadBtn.onclick = ->
        if validate()
          upload()
        return

      # Close tab when success modal is closed
      $('#updated-alert').on 'hidden.bs.modal', ->
        closePage.click()
        return


      #//////////////////
      # Main logic
      #//////////////////

      # Start form off hidden
      uploadForm.style.display = 'none'

      # Commence capturing of webcam stream
      navigator.mediaDevices.getUserMedia(constraints).then(successCallback).catch errorCallback



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: recordrtc, ACTION: edit
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('edit')
      #//////////////////
      # Setup
      #//////////////////

      editForm = document.querySelector('form')
      titleInput = editForm.querySelector('input#upload_title')
      descriptionInput = editForm.querySelector('input#upload_description')
      modalBtn = document.querySelector('button#show-modal')


      #//////////////////
      # Event watchers
      #//////////////////

      # Validate form before sending it off to server
      $('form').on 'submit', ->
        return validate()

      # Open success modal on succesful form submission
      $('form').on 'ajax:success', ->
        modalBtn.click()
        return

      # Close tab when success modal is closed
      $('#updated-alert').on 'hidden.bs.modal', ->
        closePage.click()
        return



    #///////////////////////////////////////////////////////////////////////////
    # JavaScript for CONTROLLER: recordrtc, ACTION: show
    #///////////////////////////////////////////////////////////////////////////

    if $('body').hasClass('show')
      #//////////////////
      # Setup
      #//////////////////

      # Configure SweetAlert2 popup
      window.sweetAlertConfirmConfig =
        title: 'Are you sure?'
        text: 'You will not be able to recover this recording!'
        type: 'warning'
        showCancelButton: true
        confirmButtonColor: '#DD6B55'
        confirmButtonText: 'Delete'
        cancelButtonText: 'Cancel'
  return
