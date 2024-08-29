# Openpath Mobile App Example

This app demonstrates how the use of the Openpath Mobile SDK in a SwiftUI-based iOS app.

Many parts of this app can be used in a newly developed app as-is or with small modifications:

* ``OpenpathWrapper`` is a wrapper around the Openpath SDK and API to provide some modern Swift conveniences such:
    * ``async`` calls
    * Type safety
    * ``Publisher``s that allow you to subscribe to events.

  ``OpenpathWrapper`` is reusable as-is, with the associated Model files.

* ``LoginViewModel`` encapsulates the full login logic for use by the UI layer. This can be reused with minimal
  modifications to match your app's UI flow and business needs.

* The classes in the `OpenpathAPI` folder provide access to a subset of the Openpath API. These were automatically
  generated from internal OpenAPI documents.
  
* The `AnyCodable` folder contains code from here: https://github.com/Flight-School/AnyCodable
  (This can't be included via CocoaPods because of a bug in that library's Podspec)

The UI portions of this example app are intentionally simple to allow reuse of portions if appropriate, however you will
probably want to adjust them heavily to fit your design.

## Use

* Run `bundle install` in this directory to install the required version of Cocoapods
* Run `bundle exec pod install` in this directory
* Open the Workspace in XCode
* Update the bundle ID and signing options in the project details
* Build and run


### Environment Variables

During development, it can be tedious to enter your email address and password every time you want to test the app, so
you can provide those values in the runtime environment variables ``DEBUG_EMAIL`` and ``DEBUG_PASSWORD``. You can set
those in XCode by editing the active scheme. Be careful not to use a "shared" scheme or to check those values into
source control.


