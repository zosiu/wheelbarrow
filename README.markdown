# Wheelbarrow

[![Gem Version](https://badge.fury.io/rb/wheelbarrow.svg)](http://badge.fury.io/rb/wheelbarrow)
[![Code Climate](https://codeclimate.com/github/LuckyThirteen/wheelbarrow/badges/gpa.svg)](https://codeclimate.com/github/LuckyThirteen/wheelbarrow)
[![Codeship Status for LuckyThirteen/wheelbarrow](https://www.codeship.io/projects/5f0d9af0-33fe-0132-f9b7-7a72371aeacb/status)](https://www.codeship.io/projects/40700)

## About
  Wheelbarrow is a command line utility for sending BitBucket pull requests.

## Installation
  `gem install wheelbarrow`

## Setup
  You need to create an OAuth consumer in BitBucket.

  When you invoke the command for the first time, it will:
  * ask for your OAuth consumer key
  * ask for your OAuth consumer secret
  * open the OAuth authorization page in the browser
  * ask for the OAuth verification code
  * save your OAuth creditentials in `~/.wheelbarrow/config.yml`

## Usage

    Usage:
      git bb-pull-request

    Options:
      -t, [--title=TITLE]                  # Pull request title
                                           # Default: [last commit message]
      -d, [--description=DESCRIPTION]      # Pull request description
      -b, [--target-branch=TARGET_BRANCH]  # Target branch for the pull request
                                           # Default: master

## License
  [GNU GPL v3](https://github.com/LuckyThirteen/wheelbarrow/blob/master/LICENSE)
