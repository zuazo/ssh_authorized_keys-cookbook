ssh_authorized_keys CHANGELOG
=============================

This file is used to list changes made in each version of the `ssh_authorized_keys` cookbook.

## v0.3.0 (2015-08-14)

* Use *gid* from `Etc.getpwnam` (issue [#3](https://github.com/zuazo/ssh_authorized_keys-cookbook/pull/3), thanks [Ong Ming Yang](https://github.com/ongmingyang)).
* Recursively create *.ssh* directory if it does not exist (issue [#4](https://github.com/zuazo/ssh_authorized_keys-cookbook/pull/4), thanks [Ong Ming Yang](https://github.com/ongmingyang)).
* Update chef links to use *chef.io* domain.
* Update contact information and links after migration.
* Gemfile: Update RuboCop to version `0.33.0`.
* README: Add Gemnasium and GitHub badge.

## v0.2.0 (2015-05-27)

* Sort keys always in the same order ([issue #2](https://github.com/zuazo/ssh_authorized_keys-cookbook/issues/2), thanks to [Chris Burroughs](https://github.com/cburroughs) for the idea).
* Add openSUSE as supported platform.
* Run unit tests agains Chef 11 and Chef 12.

## v0.1.0 (2015-01-11)

* Initial release of `ssh_authorized_keys`.
