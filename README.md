Agilecrm
=================

This is a ruby gem that wraps the Agile CRM API. This project is a fork of [Agile CRM Ruby API](https://github.com/anthonyfranco/agilecrm-ruby-api)!

At present, the only supported operations are are **GET**, and **POST** requests on the **contacts** resource. That means you can retrieve a list of contacts and create a new contact with whatever fields you want. This api is very early in development, but it will slowly evolve to support other kinds of operations on Agile CRM. Pull requests are always welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'agilecrm', github: 'nozpheratu/agilecrm-ruby-api'

And then execute:

    $ bundle


# Usage

To begin using this gem, Initialize the library using a configuration block including your agile **API key**, **email**, and **domain**, like this:

```ruby
AgileCRM.configure do |config|
  config.api_key = 'XXXXXXXXXXX'
  config.domain = 'my-agile-domain'
  config.email = 'myemail@example.com'
end
```

#### 1. Working with Contacts

######  To retrieve a list of contacts

```ruby
request = AgileCRM::Request.new(:get, "contacts")
request.dispatch #=> [...]
```

###### To create a new contact

```ruby
data = {
  tags: ["lead"],
  properties: [
    { type: "SYSTEM", name: "first_name", value: "Luke" },
    { type: "SYSTEM", name: "last_name",  value: "Warm" },
    { type: "SYSTEM", name: "email", subtype: "work", value: "lukewarm@example.com" }
  ]
}
request = AgileCRM::Request.new(:post, "contacts", data)
request.dispatch => {...}
```

## Contributing

1. Fork it ( https://github.com/nozpheratu/agilecrm-ruby-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
