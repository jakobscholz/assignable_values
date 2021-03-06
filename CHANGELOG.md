All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Breaking changes

### Compatible changes


## 0.15.1 - 2018-11-05

### Compatible changes

- Add `#humanized_values` for the `mutliple: true` case.


## 0.15.0 - 2018-10-26

### Breaking changes

- `#humanized_values` is deprecated, in favour of `#humanized_assignablevalues`

### Compatible changes

- `#humanized_value(value)` and `#humanized_assignable_values` now also works for the `multiple: true` case


## 0.14.0 - 2018-09-17

### Compatible changes

- Add support for Array columns using `multiple: true`.


## 0.13.2 - 2018-01-23

### Compatible changes

- Get rid of deprecation warnings on Rails 5.1+.

Thanks to irmela.


## 0.13.1 - 2017-10-24

### Compatible changes

- Add Rails 5.1 compatibility.

Thanks to GuidoSchweizer.


## 0.13.0 - 2017-09-08

### Breaking changes

- No longer support providing humanized values as a hash in favour of always using I18n.

### Compatible changes

- Fix a bug with a `has_many :through` when return a nil object.

Thanks to foobear.


## Older releases

Please check commits.
