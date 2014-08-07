[Serverspec](http://serverspec.org/) is a test framework for writing
tests for your infrastructure.
[PuppetDB](https://docs.puppetlabs.com/puppetdb/) is a data warehouse
for all the information collected by Puppet. What happens when you try
and combine the two?

This project demonstrates a very simple example of integration,
generating serverspec tests for `package`, `service`, `user` and `group`
for all nodes known to PuppetDB.

## Configuration

Currently this example only supports HTTP which is fine for testing. The
underlying PuppetDB client also supports HTTPS so it's not lots of work
to add this functionality.

Specify the address for your PuppetDB instance like so:

    export PUPPETDB_ADDRESS=http://localhost:8080

## Usage

The tests are run using Rake with:

    bundle exec rake spec

To see all the available tests you can run:

    bundle exec rake -T

This should reveal individual commands for running the tests for against
single nodes.


## Caveats

I've not done any testing of this against a large Puppet install, so
it's possible that the performance isn't great.

It also assumes you have a valid SSH configuration for accessing the
nodes with a user with sudo permissions.

You may also think that using serverspec to test for the same types that
Puppet also deals with isn't of any use. I'm not sure yet but I think
it's an interesting experiment.
