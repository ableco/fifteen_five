# FifteenFive

A simple, work-in-progress interface for the [15Five](https://my.15five.com/api/public/)
API.

## Overview

The [15Five](https://my.15five.com/api/public/) API is quite good, though some
things were designed in a particular way that it's not that common for
Rails-ready API. Those kinks have been addressed (in a way), and so far,
there's direct support for:

`Group` via `FifteenFive::Group`
`Report` via `FifteenFive::Report`
`User` via `FifteenFive::User`

Since they were built on top of the [Her gem](https://github.com/remiprev/her),
a lot of ActiveResource-like functionality is freely available:

    ```ruby
    FifteenFive::Models::User.all.to_a
    # => [#<FifteenFive::Models::User(user/954612/) ...>, ...]

    FifteenFive::Models::User.find(954612)
    # => #<FifteenFive::Models::User(user/954612/) ...>
    ```

No work has been done (yet) to handle associations due to how they relate
information (through URLs).
