# README
---

### REQUIRES

* PostgreSQL
* Ruby 2.4.0

And that's it!

### SETUP

* Use `bundle install` to install all required dependencies.
* Run `cp sample.env .env` and change the database values in the file to suit your environment.
  * RECORDRTC_RAILS_ANNOTATIONS_HOST is the hostname of where PostgreSQL is running.
  * RECORDRTC_RAILS_ANNOTATIONS_USER is the username of the database owner in PostgreSQL.
  * RECORDRTC_RAILS_ANNOTATIONS_PASS is the password of the same database owner.
* Run `rails secret` and place your generated secret keys (a different one for each Rails environment) in `.env`, for SECRET_KEY_BASE.
* Place your own LTI key and secret in `.env`, for LTI_KEY and LTI_SECRET respectively. You will most likely obtain this from the person who set up the app for your uses.
* Modify the `origins '*'` line in `config/initializers/cors.rb` by replacing the asterisk with the domain name.
* Run `rails railties:install:migrations`, `rails db:migrate` and `rails db:seed`.
* Start app with `rails s`.
* To register the app the LTI 1.0 way, use the launch URL `example.com/launch`, where `example.com` is the domain name. To register the LTI 2.0 way, use registration URL `example.com/register`.

### KNOWN BUGS

* App doesn't work in a iFrame because X-Frame-Options only allows iFrames of same domain origin (maybe after_action :disable_xframe_header?)

### TO-DO

* Add user (re)authentication where needed
* Change `config/initializers/cors.rb` to not allow every single host
* Authenticate CSRF token before accessing API
* Consider using OAuth2 gem instead of simple_oauth; check to see what is required to move over
* TBD: Add support for audio recording (if determined to be needed)

### NOTES

* As of yet, no known way to attach blob to file input in form, so a mock-form sent as XHR FormData is necessary in lieu of form_for
* Cannot separate concerns for React files
* DataTables is causing column-resizing troubles. For now, the too-large "Actions" column is not such a big deal
* Session variables are a bit iffy right now; who knows what will happen when the same person has two open instances of the tool! Shouldn't be too much of a problem as the only things I am storing in the session are unchanging.
* API is using session to get account_id and present only videos belonging to that user, which violates the statelessness of it; consider switching to JWT instead of sessions
