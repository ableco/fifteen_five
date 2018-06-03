# FifteenFive

A simple Ruby interface to the [15Five API](https://my.15five.com/api/public/).

## Overview

This gem creates a Rails-friendly interface with the [15Five API](https://my.15five.com/api/public/)
using the [Her gem](https://github.com/remiprev/her).

Her provides a lot of ActiveResource-like functionality out of the box:

    ```ruby
    FifteenFive::User.all.to_a
    # => [#<FifteenFive::Models::User(user/6243/) ...>, ...]

    FifteenFive::User.find(6243)
    # => #<FifteenFive::Models::User(user/6243/) ...>
    ```

## Limitations

* To maximize the use of Her, Her's `Association` class has been monkey-patched
  because 15Five's API is not truly RESTful :( This patch is de-facto fickle.
* The `FifteenFive::ApiSupport::ResponseParser` is hack-y, primarily because
  the 15Five API is inconsistent.
* Some methods added by Her (e.g. `Report.new().create`) will attempt to hit
  the API even though those endpoints do not exist.
* Although `BulkUserImport` and `Hello` models have been stubbed out, due to
  their non-RESTful quality, those models don't _do_ anything yet.
* Tests are non-existent.

## Road to 1.0

* [ ] Determine whether there's a better way to achieve associations via Her
      without the need for a monkey patch.
* [ ] Implement `BulkUserImport` and `Hello` models.
* [ ] Squash methods provided by Her that are not applicable and/or available
      via the 15Five API.
* [ ] Add test coverage.
* [ ] Flesh out Contribution guidelines.

## Installation (Rails)

Add the gem to your Gemfile:

    ```ruby
    gem "fifteen_five", git: "https://github.com/ableco/fifteen_five.git", tag: "v0.2.0"
    ```

Create an initializer, providing your API key:

    ```ruby
    require "fifteen_five"
    FifteenFive.setup(ENV["FIFTEENFIVE_TOKEN"])
    ```
