SSH Authorized Keys Cookbook
============================
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg?style=flat)](http://www.rubydoc.info/github/zuazo/ssh_authorized_keys-cookbook)
[![GitHub](http://img.shields.io/badge/github-zuazo/ssh__authorized__keys--cookbook-blue.svg?style=flat)](https://github.com/zuazo/ssh_authorized_keys-cookbook)
[![License](https://img.shields.io/github/license/zuazo/ssh_authorized_keys-cookbook.svg?style=flat)](#license-and-author)

[![Cookbook Version](https://img.shields.io/cookbook/v/ssh_authorized_keys.svg?style=flat)](https://supermarket.chef.io/cookbooks/ssh_authorized_keys)
[![Dependency Status](http://img.shields.io/gemnasium/zuazo/ssh_authorized_keys-cookbook.svg?style=flat)](https://gemnasium.com/zuazo/ssh_authorized_keys-cookbook)
[![Code Climate](https://img.shields.io/codeclimate/github/zuazo/ssh_authorized_keys-cookbook.svg?style=flat)](https://codeclimate.com/github/zuazo/ssh_authorized_keys-cookbook)
[![Build Status](https://img.shields.io/travis/zuazo/ssh_authorized_keys-cookbook/0.4.0.svg?style=flat)](https://travis-ci.org/zuazo/ssh_authorized_keys-cookbook)
[![Coverage Status](https://img.shields.io/coveralls/zuazo/ssh_authorized_keys-cookbook/0.4.0.svg?style=flat)](https://coveralls.io/r/zuazo/ssh_authorized_keys-cookbook?branch=0.4.0)
[![Inline docs](https://inch-ci.org/github/zuazo/ssh_authorized_keys-cookbook.svg?branch=master&style=flat)](https://inch-ci.org/github/zuazo/ssh_authorized_keys-cookbook)

[Chef](https://www.chef.io/) cookbook to create SSH authorized keys files in user home directories.

Tries to avoid generating a corrupt file that could render your server inaccessible.

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* AIX
* Amazon Linux
* Debian
* CentOS
* Fedora
* FreeBSD
* openSUSE
* RedHat
* SUSE
* Ubuntu

Please, [let us know](https://github.com/zuazo/ssh_authorized_keys-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Applications

* Chef `12` or higher.
* Ruby `2.3` or higher.

Definitions
===========

## ssh_authorize_key

Authorize a key for public key authentication using SSH.

**Warning:** This definition uses the [Accumulator Pattern](http://docs.chef.io/definitions.html#many-recipes-one-definition). This implies that any SSH key added using other methods (such as **keys added by hand**) will be **deleted**.

## ssh_authorize_key Parameters

| Parameter    | Default           | Description                              |
|:-------------|:------------------|:-----------------------------------------|
| user         | `nil`             | System user **(required)**.              |
| group        | user              | System group.                            |
| home         | *calculated*      | System user home path.                   |
| key          | `nil`             | SSH public key in base64 **(required)**. |
| keytype      | `'ssh-rsa'`       | SSH key type.                            |
| comment      | *definition name* | SSH key comment.                         |
| options      | `nil`             | SSH key options as a hash.               |
| validate_key | `true`            | Enable/Disable assert_key                |

Usage Examples
==============

First of all, don't forget to include the `ssh_authorized_keys` cookbook as a dependency in the cookbook metadata:

```ruby
# metadata.rb
# [...]

depends 'ssh_authorized_keys'
```

You can use the `ssh_authorize_key` to authorize SSH public keys to use SSH public key authentication:

```ruby
# Bob is the admin here.

ssh_authorize_key 'bob@acme.com' do
  key 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCctNyRouVDhzjiP[...]'
  user 'root'
end

ssh_authorize_key 'alice@acme.com' do
  key 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCySLKbpFRGCrKU/[...]'
  user 'alice'
end
```

## Setting the SSH Key Options Field

You can set the options field as follows:

```ruby
# As the root user by default in ubuntu:
ssh_authorize_key 'bob@acme.com' do
  key 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCctNyRouVDhzjiP[...]'
  user 'root'
  options(
    'no-port-forwarding' => true,
    'no-agent-forwarding' => true,
    'no-X11-forwarding' => true,
    command:
      'echo \'Please login as the user "bob" rather than the user "root".\''\
      ';echo;sleep 10'
  )
end
```

## Reading the Keys from a Data Bag

For example, from the following data bag item:

```json
{
  "id": "users",
  "bob@acme.com": {
    "key": "AAAAB3NzaC1yc2EAAAADAQABAAABAQCctNyRouVDhzjiP[...]",
    "user": "root"
  },
  "alice@acme.com": {
    "key": "AAAAB3NzaC1yc2EAAAADAQABAAABAQCySLKbpFRGCrKU/[...]",
    "user": "alice"
  }
}
```

You can read the data bag item from a recipe as follows:

```ruby
users = data_bag_item('ssh', 'users')
users.delete('id')

users.each do |name, ssh_key|
  ssh_authorize_key name do
    key ssh_key['key']
    user ssh_key['user']
  end
end
```

See [the data bags DSL documentation](http://docs.chef.io/data_bags.html#load-with-dsl-recipe) for a more detailed explanation and [the data bags knife documentation](http://docs.chef.io/data_bags.html#using-knife-title) to learn how to create a data bag.

Attributes
==========

These attributes are primarily intended to support the different platforms. Do not touch them unless you know what you are doing.

| Attribute                                 | Default      | Description            |
|:------------------------------------------|:-------------|:-----------------------|
| `node['ssh_authorized_keys']['keytypes']` | *calculated* | Allowed SSH key types. |

Testing
=======

See [TESTING.md](https://github.com/zuazo/ssh_authorized_keys-cookbook/blob/master/TESTING.md).

## ChefSpec Tests

To create ChefSpec tests for the `ssh_authorize_key` definition, you can use the [`render_file`](http://www.rubydoc.info/github/sethvargo/chefspec#render_file) matcher to check the *authorized_keys* file content:

```ruby
it 'allows bob to login as root' do
  expect(chef_run).to render_file('/root/.ssh/authorized_keys')
    .with_content(/^ssh-rsa [A-Za-z0-9+\/=]+ bob@acme\.com$/)
end
```

You can also test against the internal template:

```ruby
it 'creates ~bob/.ssh/authorized_keys file' do
  expect(chef_run).to create_template('/home/bob/.ssh/authorized_keys')
end
```

Contributing
============

Please do not hesitate to [open an issue](https://github.com/zuazo/ssh_authorized_keys-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/zuazo/ssh_authorized_keys-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/zuazo/ssh_authorized_keys-cookbook/blob/master/TODO.md).


License and Author
=====================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Raul Rodriguez](https://github.com/raulr) (<raul@onddo.com>)
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@zuazo.org>)
| **Contributor:**     | [Ong Ming Yang](https://github.com/ongmingyang)
| **Contributor:**     | [MVNW](https://github.com/MVNW)
| **Contributor:**     | [Anthony Caiafa](https://github.com/acaiafa)
| **Copyright:**       | Copyright (c) 2015-2016, Xabier de Zuazo
| **Copyright:**       | Copyright (c) 2015, Onddo Labs, SL.
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
