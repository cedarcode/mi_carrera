# README

## Development

Running tests (Chrome by default)

```
$ bundle exec rake
```

Running tests in Firefox
```
$ TEST_BROWSER=firefox bundle exec rake
```

## Gem Update Policy

### Gemfile Version Constraints

In `Gemfile` define gem dependencies using a version contrainst of `~> MAJOR.MINOR` by default, unless you have reasons
to use something different. An example of an exception could be `rails`, which is known to make backwards-incompatible
changes in minor level updates, so in that case we use `~> MAJOR.MINOR.PATCH`.

### Updating

[Updating gems cheat sheet](https://medium.com/cedarcode/updating-gems-cheat-sheet-346d5666a181)
