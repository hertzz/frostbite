# Frostbite

[![Build Status](https://travis-ci.org/tommyjohnson/frostbite.svg?branch=master)](https://travis-ci.org/tommyjohnson/frostbite)

### Reporting

The Frostbite reporting app allows you to generate HTML reports based off defined provider endpoints. Reports can be configured for what data they will gather and how they are to be structured for output. 

## Getting Started

Run on your local machine

```
$ git clone git@github.com:tommyjohnson/frostbite.git
$ cd frostbite
```

### Provider configuration

A customer configuration file must be passed in to the reporting application. To configure a customer config file, you can duplicate the `customer.yml.example` to a new customer definition file.

```
$ cd config/customers
$ cp customer.yml.example <customer>.yml
```

Modify the very first attribute, `customer`, in the new customer YAML file to match the configuration filename (minus the .yml).

#### Zendesk

In the customers configuration file, you must modify the following attributes underneath the `zendesk` property:

* `url`
    * Zendesk account API URL (https://example.zendesk.com/api/v2)
* `auth_email`
    * Agents email address
* `auth_token`
    * Agents authorization token
* `organization`
    * Organization name which matches the YML file name

##### Collections

Currently, there are two types of ticket collection categories:
```
PLEASE NOTE:

Collection names are unique as they are referenced directly from within
the ERB templates.
```

* `open_tickets:`
    * Returns tickets with the status of `Open` or `New`
* `solved_tickets:`
    * Returns tickets with the status of `Solved` or `Closed` 
* `closed_tickets:` (Alias of `solved_tickets`)
    *  Returns tickets with the status of `Solved` or `Closed`

Each collection category can have the following optional child properties set to modify searchable time ranges:

* `- date_start: <date>`
    * Starting date range to search for in filtered results 
* `- date_end: <date>`
    * Ending date range to search for in filtered results 

### Template configuration

A customer template file must be passed in to the reporting application. To configure a customer template file, you can duplicate the customer.html.erb.example to a new customer template file.

```
$ mkdir templates/<customer-name>
$ cp example/customer.html.erb.example <customer-name>/monthly.html.erb
```

Inside the template file, there are two pre-defined `field` blocks. The `@fields` object holds all of the results from when the report engine gathers all the data from your defined endpoints.

The first `field` block itterates through the Zendesk `open_tickets` collection and displays each ticket as a seperate unordered list item with a hyperlink to the zendesk URL.

Much like the first `field` block, the second one is fairly similar, however it displays tickets returned which match the `solved_tickets` collection.

These blocks can be modified in any way, however the outer part of the loop on the initial `@fields` object, must stay present, as with the inner `t.each` and `st.each` blocks.

### Running the application

```
$ ./bin/frostbite -c config/customers/<customer>.yml -t templates/<customer>/report.html.erb
```

For a full list of available commandline options, run the following:
```
./bin/frostbite -h

Usage: reporting [OPTIONS]

Specific options:
    -c, --customer FILE              Customer configuration file to use for report
    -t, --template FILE              Customer template file to use for report

Common options:
    -v, --verbose                    Run verbosely
    -h, --help                       This menu
        --version                    Show version
```

## Developer Notes

### GitHub Setup

Run on your local machine

```
$ git clone git@github.com:tommyjohnson/frostbite.git
$ cd frostbite
```

Configure Git credentials

```
$ git config --global user.name "Your Name"
$ git config --global user.email <your_email>
```

Configure remote branch tracking for `develop` and `master` branches

```
$ git branch --set-upstream develop origin/develop
$ git branch --set-upstream master origin/master
```

Always ensure to rebase your branches before doing anything

```
$ git checkout master
$ git pull --rebase
```

### Adding functionality/features

When adding functionality to the application, you need to ensure you create a feature branch based off `origin/master`.

To do this, run the following on your local machine

```
$ git checkout cusrep-<feature-name>-feature
```

Once you have completed development and tested your feature, run the following:

```
$ git add <files>
$ git commit -m "Your message" -a
$ git push -u origin cusrep-<feature-name>-feature
```

* Submit a pull request to merge your feature branch into master
* Have someone review your pull request and merge the changes
