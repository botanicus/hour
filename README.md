# About
[![Build status][BS img]][Build status]
[API docs](https://botanicus.github.io/hour/)

Hour class to work with hours, minutes and seconds, convert between various units and format the output.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  hour:
    github: botanicus/hour
```

## Usage

```crystal
require "hour"

hour = Hour.from(minutes: 85)
puts "It's #{hour.hours.value}:#{hour.minutes.value}!"

hour = Hour.new(1, 25) + Hour.new(s: 10)
puts "It's #{hour.to_s}!"

puts "The system time is #{Hour.now}!"
```

# Development

```shell
gem install guard guard-shell

# Watch for changes and run tests, generate documentation and fix formatting.
guard
```

# TODO

- Fix TODOs in the code.
- Release version 0.1.

[Build status]: https://travis-ci.org/botanicus/hour
[BS img]: https://travis-ci.org/botanicus/hour.svg?branch=master
