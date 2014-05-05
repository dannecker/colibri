Colibri Installer
===============

**Until the release of Colibri 1.0 you must use the --edge option**

Command line utility to create new Colibri store applications
and extensions

See the main colibri project: https://github.com/colibri/colibri

Installation
------------

```ruby
gem install colibri_cmd
```
This will make the command line utility 'colibri' available.

You can add Colibri to an existing rails application

```ruby
rails new my_app
colibri install my_app
```

Extensions
----------

To build a new Colibri Extension, you can run
```ruby
colibri extension my_extension
```
Examples
--------

If you want to accept all the defaults pass --auto_accept

colibri install my_store --edge --auto_accept

to use a local clone of Colibri, pass the --path option

colibri install my_store --path=../colibri


Options
-------

* `--auto_accept` to answer yes to all questions
* `--edge` to use the edge version of Colibri
* `--path=../colibri` to use a local version of colibri
* `--git=git@github.com:cmar/colibri.git` to use git version of colibri
  * `--branch=my_changes` to use git branch
  * `--ref=23423423423423` to use git reference
  * `--tag=my_tag` to use git tag


