# FifteenFive

A simple, work-in-progress interface for the [15Five API](https://my.15five.com/api/public/).

## Overview

This gem creates a Rails-friendly interface with the [15Five API](https://my.15five.com/api/public/)
using the [Her gem](https://github.com/remiprev/her). Her provides a lot of 
ActiveResource-like functionality out of the box:

```ruby
FifteenFive::User.all.to_a
# => [#<FifteenFive::Models::User(user/6243/) ...>, ...]

FifteenFive::User.find(6243)
# => #<FifteenFive::Models::User(user/6243/) ...>
```

## Limitations

- Not all of the available endoints have associated models yet.
- No work has been done to handle associations (due to the URL format
provided by the API).

## Installation (Rails)

Add the gem to your Gemfile:

```ruby
gem "fifteen_five", git: "https://github.com/ableco/fifteen_five.git", tag: "v0.1.0
```

Create an initializer, providing your API key:

```ruby
require "fifteen_five"
FifteenFive.setup(ENV["FIFTEENFIVE_TOKEN"])
```
