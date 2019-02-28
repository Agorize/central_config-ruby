# CentralConfig

This gem is an adapter for the central configuration of Agorize. It provides easy access
to _feature flags_ and _settings_ through a simple API.

Under the hood it leverages [Flagr] but this should be able to change without having to
change the code using this gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'central_config'
```

And then execute:

    $ bundle

## Gem configuration

CentralConfig will automatically pickup the following environment variables:

```
CENTRAL_CONFIG_FLAGR_HOST="https://flagr.agorize.com"
```

You can also override the gem settings in an initializer:

```ruby
# config/initializers/central_config.rb
CentralConfig.configure do |config|
  config.flagr_host = 'https://flagr.agorize.com'
end
```

To get the list of configuration options you can generate the initializer by calling:

```
rails generate central_config:install
```

## Fetching all the flags

In order to avoid calling Flagr multiple times for a single request, you need to send the
context once and get all the flags in a single batch.

If you're sending user-related information, this must happen **after** you authenticate
the user for signed-in pages.

```ruby
before_action :fetch_central_config

private

def fetch_central_config
  CentralConfig.load(
    entity_id: '<user specific or anonymous identifier>',
    context: {
      email: current_user&.email,
      browser: browser.name,
      lang: I18n.locale,
      domain_name: request.domain,
      env: Rails.env
    })
end
```

## Getting feature flags

You can access a _feature flag_ value using the `central_flag?` helper. It will either
return `true` or `false` according to what the Central Config System returns.

```ruby
central_flag?(:communities_admin)
# => true or false
```

### Providing a default value

If the API doesn't know the flag or fails to respond, it's always better to provide a
default value.

```ruby
central_flag?(:communities_admin)
# => false

central_flag?(:communities_admin, default: true)
# => true

central_flag?(:communities_admin) { true }
# => true

flag_service = -> { true }
central_flag?(:communities_admin) { flag_service.call }
# => true
```

### Flag naming

Note that today CentralConfig interacts with [Flagr] and will fetch flags by prefixing the
key with `flag_`.

```ruby
central_flag?(:communities_admin)
# Will fetch the value from flagKey: "flag_communities_admin"
```

## Getting settings

To obtain a single setting use the `central_setting` helper. It will return the variant
attachment stored by [Flagr].

```ruby
central_setting(:site_logo)
# => { 'url' => 'total.svg' }
```

### Providing a default value

If the API doesn't know the flag or fails to respond, it's always better to provide a
default value.

```ruby
central_setting(:site_logo)
# => {}

central_setting(:site_logo, default: { url: 'agorize.svg' })
# => { url: 'agorize.svg' }

central_setting(:site_logo) { { url: 'agorize.svg' } }
# => { url: 'agorize.svg' }

logo_service = -> { { url: 'agorize.svg' } }
site_logo = central_setting(:site_logo) { logo_service.call }
# => { url: 'agorize.svg' }
```

### Specific attachment item

You may also want to directly access a specific information from the setting. You can do
so by specifying the path of the information you want, it will be passed to a `dig` call
under the hood.

```ruby
central_setting(:site_logo, :url)
# => 'total.svg'
```

In this situation, you can provide a default value for the specified item.

```ruby
central_setting(:site_logo, :url, default: 'total.svg')
# => 'total.svg'

central_setting(:site_logo, :url) { 'total.svg' }
# => 'total.svg'
```

### Setting naming

Note that today CentralConfig interacts with [Flagr] and will fetch settings by prefixing
the key with `setting_`.

```ruby
central_setting(:site_logo)
# Will fetch the value from flagKey: "setting_site_logo"
```

[Flagr]: https://checkr.github.io/flagr
