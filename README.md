glazier-server
==============
[![Build Status](https://travis-ci.org/yapplabs/glazier-server.png?branch=master)](https://travis-ci.org/yapplabs/glazier-server)

A Rails-based server for [yapplabs/glazier](https://github.com/yapplabs/glazier)

# Getting started

## Install dependencies

````
gem install bundler
bundle install
````

## Set up API credentials

Create a Github app for your Glazier instance
 -> http://github.com/settings/applications/new

Enter anything you like for Application Name. ("glazier-dev", perhaps?)
For Main URL, enter "http://localhost:8000"
For Callback URL, enter "http://localhost:8000/oauth/github/callback"

That will give you access to the a client ID and client secret for your new Github application. Add environment variables with these values: **GLAZIER_GITHUB_CLIENT_ID** and **GLAZIER_GITHUB_CLIENT_SECRET**.

## Start the server

    bundle exec rails server -p 3040

# Running specs

glazier-server uses RSpec for unit tests. To run them:

    bundle exec rake

To automatically execute specs as you update code and specs:

    bundle exec guard
