# README
---

This is the open-source version of the app!



Ruby 2.4.0 + Rails 5.1.1 (+ FFMPEG for recording thumbnails).  
Use `bundle install` to install all required dependencies.  
Run `cp sample.env .env` and change the values in the file to suit your environment.  
Run `cp config/initializers/sample.secret_token.rb config/initializers/secret_token.rb` and place your generated secret key (follow instructions in file) in `secret_key_base`.


### KNOWN BUGS
* IMS-LTI gem version 2.1.2 produces ``undefined method `valid_signature?'`` error; must use 2.0.0beta41 for now

### TO-DO
* Rename and organize controllers and routes
* Find error in IMS-LTI 2.1.2 gem
* Separate recordings per user (ask Jesus how to use LTI data to separate user object ownership). Also separate recordrtc controller views per user (ex.: user 1 has recordings id 1, 2 and 3, and user 2 has separate recordings id 1, 2, 3 and 4. Neither can access each others' edit or show pages)
* Examine security of certain routes opened up by js-routes
* OPTIONAL: Add video thumbnails to home page
* OPTIONAL: Integrate Shrine's URL storage for cache
* TBD: Add support for audio recording (if determined to be needed)

### NOTES

* xmlUrl = the generated url
* generatedXML = the generated xml in the container
* As of yet, no known way to attach blob to file input in form, so a mock-form sent as XHR FormData is necessary in lieu of form_for
* Some other controllers (such as registration) had CSS/JS in a file that did not match the controller name (registration had CSS in guide); eventually these styles will have to be added to their own file
* Cannot separate concerns for React files
* Is it really a good idea to constantly be sending AJAX requests? Not very scalable, messes with search box (solution: find way to refresh page without resetting session)
  * Issue with reloading LTI launch page is due to there being no GET route to /recordrtc. Need to find way to implement, how to keep LTI launch parameters?
* As of yet, have not found a way to close show view after deleting recording, so the link is commented out for now
* DataTables is causing column-resizing troubles. For now, the too-large "Actions" column is not such a big deal
* PARTIALLY STARTED INTEGRATING GAFFE. Can start replacing old JSON response code with Gaffe-specific code