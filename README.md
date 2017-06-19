# README
---

This is the open-source version of the app!



Ruby 2.4.0 + Rails 5.1.1 (+ FFMPEG for recording thumbnails).  
Use `bundle install` to install all required dependencies.  
Run `cp sample.env .env` and change the values in the file to suit your environment.  
Run `cp config/initializers/sample.secret_token.rb config/initializers/secret_token.rb` and place your generated secret key (follow instructions in file) in `secret_key_base`.

### KNOWN BUGS

* CoffeeScript for registration controller doesn't work, as the registration view is wrapped in the LMS's HTML and doesn't have its own controller/action-identified body tag
* App doesn't work in a iFrame because X-Frame-Options only allows iFrames of same domain origin (maybe after_action :disable_xframe_header?)
* Gaffe error pages might not work with people who haven't POSTed an LTI launch as it does not skip the authentication token verification

### TO-DO

* Remove useless CSS from specific pages
* Rename and organize controllers and routes
* Consider using OAuth2 gem instead of simple_oauth; check to see what is required to move over
* Separate recordings per user (ask Jesus how to use LTI data to separate user object ownership). Also separate recordrtc controller views per user (ex.: user 1 has recordings id 1, 2 and 3, and user 2 has separate recordings id 1, 2, 3 and 4. Neither can access each others' edit or show pages)
* Examine security of certain routes opened up by js-routes
* OPTIONAL: Add video thumbnails to home page
* OPTIONAL: Integrate Shrine's URL storage for cache
* TBD: Add support for audio recording (if determined to be needed)

### NOTES

* As of yet, no known way to attach blob to file input in form, so a mock-form sent as XHR FormData is necessary in lieu of form_for
* Cannot separate concerns for React files
* Is it really a good idea to constantly be sending AJAX requests? Not very scalable, messes with search box (solution: find way to refresh page without resetting session)
  * Issue with reloading LTI launch page is due to there being no GET route to /recordrtc. Need to find way to implement, how to keep LTI launch parameters?
* As of yet, have not found a way to close show view after deleting recording, so the link is commented out for now
* DataTables is causing column-resizing troubles. For now, the too-large "Actions" column is not such a big deal
* Gaffe integration is all default, can customize more later for regular path errors and API errors

### TRY

Checking for @message instead of @message.lti_version == 'LTI-2p0'