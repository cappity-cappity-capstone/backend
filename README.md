# Cappy Backend

This repository holds the backend for NU Capstone 2015 Group W5.
The backend is written in Ruby, using Sinatra, ActiveRecord, SQLite3, and unicorn.
Its purpose is twofold: to serve the JSON views for the application frontend, and to control the other devices.

## Getting Started
```
git clone git@github.com:cappity-cappity-capstone/backend.git
cd backend
bundle
rake db:create
rake db:migrate
bundle exec rake
```

## Development

All development tasks for this application are handled through the Rakefile.
To see a complete listing, run `bundle exec rake -T`.

## Schema

For the different modules, we'll be using two tables: `devices` and `states`.
`devices` represent the actual modules that are connected, while `states` represent the state of each module.

### `device`

Here's the basic structure of the devices table:

```
+--------------------+
| devices            |
+--------------------+
| id:int             |
| device_id:string   |
| name:string        |
| type:string        |
| last_check_in:time |
| created_at:time    |
| updated_at:time    |
+--------------------+
```

Things to note:

* `device_id` is the unique id that is reported by the module
* `name` is an optional string that is set by the user
* `type` should be enforced to be one of the following:
  * `lock`
  * `outlet`
  * `gas_valve`
  * `airbourne_alert`
* `last_check_in` is the time tha ccs last interacted with the module.


The device `has_many` `states`, which is described below.

### `states`

The state table is very straightforward:

```
+-----------------------+
| states                |
+-----------------------+
| id:int                |
| state:int             |
| device_id:foreign_key |
| created_at:time       |
+-----------------------+
```

There should be an index on the `device_id` column to enable quick searching.
