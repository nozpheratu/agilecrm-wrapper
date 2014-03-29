Agile CRM Ruby API
=================

Ruby Client to Access Agile CRM Functionality

This is a thin wrapper around the Agile CRM API similar to the PHP API located here:
https://github.com/agilecrm/php-api

Feel free to email me at anthony@bettercater.com with any questions.

# Intro
1. Load the agilecrm.rb file into your project
  ```ruby
  load 'agilecrm.rb'
  ```

2. Initialize the library file with your ***agile API key*** and ***agile domain***
  ```ruby
  AgileCRM.api_key = 'XXXXXXXXXXX'
  AgileCRM.domain = 'mydomain'
  ```

4. You need to provide 3 parameters to the request method. They are **HTTP method**, **subject**, and **data**.

  a. **HTTP method** must to set to

```
	:post if you need to add an entity to contact like tags, or contact itself.

	:get if you need to fetch an entity associated with the contact.
	
	:put to update contact properties, add / subtract score, or remove tags.

	:delete to delete a contact.
```

  b. **subject** should be one of "contact", "tags", "score", "note", "task", "deal".

  c. **data**  format should be as shown below. Email is mandatory.
	
```ruby
 contact_data = { email: "contact@test.com", first_name: "test", last_name:  "contact" }
```
	

# Usage

#### 1. Contact

###### 1.1 To create a contact

```ruby
contact_data = { email: "contact@test.com", first_name: "test", last_name: "contact" }
AgileCRM.request :post, "contact", contact_data
```
