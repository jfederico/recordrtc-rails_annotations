# README
---

### REQUIRES

* PostgreSQL
* Ruby 2.4.0

And that's it!

### SETUP

* Use `bundle install` to install all required dependencies.
* Run `cp sample.env .env` and change the database values in the file to suit your environment.
* Run `rails secret` and place your generated secret keys (a different one for each Rails environment) in `.env`.
* Place your LTI key and secret in `.env`.
* Modify the `origins '*'` line in `config/initializers/cors.rb` by replacing the asterisk with the domain name.
* Run `rails railties:install:migrations`, `rails db:migrate` and `rails db:seed`.
* Start app with `rails s`.
* To register the app the LTI 1.0 way, use the launch URL `example.com/launch`, where `example.com` is the domain name. To register the LTI 2.0 way, use registration URL `example.com/register`.

### KNOWN BUGS

* App doesn't work in a iFrame because X-Frame-Options only allows iFrames of same domain origin (maybe after_action :disable_xframe_header?)
* js-routes initializer isn't working (all routes are open for now, the regexes aren't matching properly)

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
