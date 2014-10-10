AgileCRM Ruby Client
=================

This project is a ruby client that wraps the [AgileCRM REST API](https://www.agilecrm.com/api/rest). **Note: This is not an official project, you're welcome to use it but don't expect the AgileCRM team to support it.**

At present, the only supported operations are are **GET**, and **POST** related operations on the **contacts** resource. That means you can retrieve a list of contacts and create a new contact with whatever fields you want. This client is early in development, but it will slowly evolve to support other kinds of operations. Pull requests are always welcome.

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

### 1. Working with Contacts
Only the following Contact operations are supported. Methods not listed here either have issues on AgileCRM's side or are being worked on.

###### To retrieve a list of contacts
```ruby
AgileCRM::Contact.all
```

###### To get an individual contact by ID
```ruby
AgileCRM::Contact.find(123)
```

###### To create a new contact
```ruby
AgileCRM::Contact.create(
  tags: ["tag", "your", "it"],
  first_name: "Justin",
  last_name: "Case",
  email: "blah@mail.com",
  my_custom_field: "im a custom field!"
)
```

###### To delete a single contact
```ruby
# perform operation directly
AgileCRM::Contact.delete(123)
# or
AgileCRM::Contact.find(123).destroy
```

**GET** operations return one or more `AgileCRM::Contact` objects. These are just `Hashie::Mash` objects with a few utility methods sprinkled on. You can access any of the Contact fields returned by AgileCRM's REST API, see [here](https://www.agilecrm.com/api/rest#contact-fields) for what that entails. Example:
```ruby
contact = AgileCRM::Contact.find(123)
contact.tags #=> ["tag", "your", "it"]
contact.id #=> 123
contact.properties #=> [{ type: 'SYSTEM', name: "email", value: "blah@mail.com" }]
```

The aforementioned utility methods presently only includes the `destroy` method, which when called on a Contact instance will fire off an HTTP **DELETE** request to the corresponding contact.

## Contributing

1. Fork it ( https://github.com/nozpheratu/agilecrm-ruby-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
