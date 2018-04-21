# Xf

[![Gem Version](https://badge.fury.io/rb/xf.svg)](http://badge.fury.io/rb/xf)
<!-- Replace <id> with Code Climate repository ID. Remove this comment afterwards. -->
[![Maintainability](https://api.codeclimate.com/v1/badges/905faea654f9e0a1f811/maintainability)](https://codeclimate.com/github/baweaver/xf/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/905faea654f9e0a1f811/test_coverage)](https://codeclimate.com/github/baweaver/xf/test_coverage)
[![Build Status](https://travis-ci.org/baweaver/xf.svg?branch=master)](https://travis-ci.org/baweaver/xf)

<!-- Tocer[start]: Auto-generated, don't remove. -->

## Table of Contents

  - [Features](#features)
  - [Screencasts](#screencasts)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Usage](#usage)
  - [Tests](#tests)
  - [Versioning](#versioning)
  - [Code of Conduct](#code-of-conduct)
  - [Contributions](#contributions)
  - [License](#license)
  - [History](#history)
  - [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

## Features

**Compose**

```ruby
%w(1 2 3 4).map(&Xf.compose(:to_i, :succ))
```

If it looks like a Proc, or can be convinced to become one, it will work there.

**Scopes**

A Scope is a play on a [concept from Haskell called a Lense](http://hackage.haskell.org/package/lens-tutorial-1.0.3/docs/Control-Lens-Tutorial.html).

The idea is to be able to define a path to a transformation and either get or
set against it as a first class function. Well, easier shown than explained.

To start with we can do a few gets:

```ruby
people = [{name: "Robert", age: 22}, {name: "Roberta", age: 22}, {name: "Foo", age: 42}, {name: "Bar", age: 18}]

people.map(&Xf.scope(:age).get)
# => [22, 22, 42, 18]
```

Let's try setting a value:

```ruby
people = [{name: "Robert", age: 22}, {name: "Roberta", age: 22}, {name: "Foo", age: 42}, {name: "Bar", age: 18}]

older_people = people.map(&Xf.scope(:age) { |age| age + 1 })

older_people = people.map(&Xf.scope(:age).set { |age| age + 1 })
# => [{:name=>"Robert", :age=>23}, {:name=>"Roberta", :age=>23}, {:name=>"Foo", :age=>43}, {:name=>"Bar", :age=>19}]

people
# => [{:name=>"Robert", :age=>22}, {:name=>"Roberta", :age=>22}, {:name=>"Foo", :age=>42}, {:name=>"Bar", :age=>18}]

# set! will mutate, for those tough ground in issues:

older_people = people.map(&Xf.scope(:age).set! { |age| age + 1 })
# => [{:name=>"Robert", :age=>23}, {:name=>"Roberta", :age=>23}, {:name=>"Foo", :age=>43}, {:name=>"Bar", :age=>19}]

people
# => [{:name=>"Robert", :age=>23}, {:name=>"Roberta", :age=>23}, {:name=>"Foo", :age=>43}, {:name=>"Bar", :age=>19}]
```

It works much the same as `Hash#dig` in that you can pass multiple comma-seperated values as a deeper path:

```
Xf.scope(:children, 0, :name).get.call({name: 'Foo', children: [{name: 'Bar'}]})
# => "Bar"

Xf.scope(:children, 0, :name).set('Baz').call({name: 'Foo', children: [{name: 'Bar'}]})
# => {:name=>"Foo", :children=>[{:name=>"Baz"}]}
```

That means array indexes work too, and on both `get` and `set` methods!

## Screencasts

## Requirements

0. [Ruby 2.3.7](https://www.ruby-lang.org)

## Setup

To install, run:

    gem install xf

Add the following to your Gemfile:

    gem "xf"

## Usage

## Tests

To test, run:

    bundle exec rake

## Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Major (X.y.z) - Incremented for any backwards incompatible public API changes.
- Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
- Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## License

Copyright 2018 [Brandon Weaver]().
Read [LICENSE](LICENSE.md) for details.

## History

Read [CHANGES](CHANGES.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

## Credits

Developed by [Brandon Weaver]()
