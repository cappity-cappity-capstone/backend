# Cappy Backend
[![build status](https://img.shields.io/travis/cappity-cappity-capstone/backend.svg?style=flat)](https://travis-ci.org/cappity-cappity-capstone/backend)
[![dependencies](https://img.shields.io/gemnasium/cappity-cappity-capstone/backend.svg?style=flat)](https://gemnasium.com/cappity-cappity-capstone/backend)

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

For the different devices, we'll be using two tables: `devices` and `states`.
`devices` represent the actual devices that are connected, while `states` represent the state of each device.

### `device`

Here's the basic structure of the devices table:

```
+--------------------+
| devices            |
+--------------------+
| id:int             |
| device_id:string   |
| name:string        |
| device_type:string |
| unit:string        |
| last_check_in:time |
| created_at:time    |
| updated_at:time    |
+--------------------+
```

Things to note:

* `device_id` is the unique id that is reported by the device
* `name` is an optional string that is set by the user
* `device_type` should be enforced to be one of the following:
  * `lock`
  * `outlet`
  * `gas_valve`
  * `airbourne_alert`
* `last_check_in` is the time that ccs last interacted with the device.


The device `has_many` `states`, which is described below.

### `states`

The state table is very straightforward:

```
+-----------------------+
| states                |
+-----------------------+
| id:int                |
| device_id:foreign_key |
| state:decimal         |
| source:string         |
| created_at:time       |
+-----------------------+
```

There should be an index on the `device_id` column to enable quick searching.

## Device to Backend API

### DeviceType enum

* airborne_alert
* gas_valve
* outlet
* lock

### Register device

> POST /devices

#### Body

    {
      "device_id": "#{device_id}",
      "type": one of DeviceType,
      "unit": "g/cm3"
    }

#### Responses

> #### 201
> Newly added device

> #### 200
> Reattached to previous device

### Watchdog timer

> PUT /devices/#{device_id}/watchdog

#### Responses

> #### 200
> Device exists
> #### 400
> Device needs to reregister

### State devices status

> GET /devices/#{device_id}/status

#### Responses

> #### 200

    {
      "device_id": "#{device_id}",
      "state": 0.0
    }

> #### 404
> No known device. Should register

### Send alert status

> POST /devices/#{device_id}/status

    {
      "state": 0.0
    }

#### Responses

> #### 200

> #### 404
> No known device. Should register
