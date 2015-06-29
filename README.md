[![Build Status](https://travis-ci.org/sul-dlss/assembly.svg?branch=master)](https://travis-ci.org/sul-dlss/assembly)
[![Dependency Status](https://gemnasium.com/sul-dlss/assembly.svg)](https://gemnasium.com/sul-dlss/assembly)

# Assembly Robot Suite

Uses ruby 1.9.3

## Dependencies

Check dependencies for jp2 creation in the `assembly-image` gem.

## Version History

- 1.0.0  Released to production
- 1.2.0  Changed expected checksum behavior from <provider_checksum> node to regular <checksum> node.  Eliminated checksum_compare robot.  Must be run in combination with pre-assembly 1.2.0.
- 1.2.2  Downcase checksums from provider before comparing them
- 1.3.0  Only create derivates for resource type=image or resource type=page
- 1.3.2  Prepare for release listing on DLSS release board
- 1.3.3  Update to use new DruidTools gem and new assembly-utils gem
- 1.3.4  Update to latest version of lyber-core gem, which allows robots to sleep and try again if the workflow service call fails
- 1.4.0  Update robots so that they will find content and metadata files in both the old style (oo/000/oo/0001) and the new style (oo/000/oo/0001/content and oo/000/oo/0001/metadata)
- 1.4.1  update web service call to remove "v1" from URL
- 1.4.2  When generating the source path to pass to the initiate workspace web service call, determine if we are using the new druid tree folder or the older style.  Send the source path to the correct location.
- 1.4.3  don't overwrite mimetype or filesize if it already exists in content metadata
- 1.4.4  Show more detailed error messages when computing checksums fail
- 1.5.0  allow multiple root directories to be specified so that we can have the robots look in directories other than '/dor/assembly' to find the content
- 1.5.1  Update service_root configuration to allow different service URLs (e.g. with or without v1) for test and production 
- 1.5.2  Require latest versions of assembly-image and assembly-objectfile to prevent problems that could occur with spaces in image filenames
- 1.5.3  Don't create another JP2 if one with the same DPG basename already exists; allow overwrite settings to be configured by environment
- 1.6.0  Only run checksum-compute, exif-collect and jp-create on object types of ITEM.  APOs and Collections will not error out even without contentMetadata.
- 1.6.1  Add some additional logging and slight refactoring; make skipping of non-items configurable
- 1.6.2  Bug fixes related to caching of Dor::Item in Assembly::Item class for multiple items being processed
- 1.6.3  Add new config parameter to set tmp folder location for jp2-create and imagemagick
- 1.6.4  Update to latest version of assembly gems to allow jp2 creation to occur when color profiles are missing
- 1.6.5  Update to latest version of assembly gems to avoid EXIF UTF-8 issues
- 1.6.6-1.6.8  Update to latest version of assembly-image gem
- 1.6.9  Exif collect robot will only add image data node if it is not there

## Running tests

    Copy config/environments/local.example.rb to config/environments/development.rb
    bundle exec rspec spec

## Deployment

    cap testing deploy  # for test
    cap production deploy # for production

Enter the branch or tag you want deployed.

See the `Capfile` for more info

## General notes on the assembly robots

The assembly robots do not interact with DOR, except for the workflow changes
provided by robot framework. Instead, all of the work occurs directly in the
file system (in the object's druid tree directory).

Typically, a robot does some work and then adds more information to the
`contentMetadata.xml` file sitting in the druid tree directory.

## Robots

- Create JP2.
- Compute and compare checksums.
- Compute image attributes.
- Initiate the common-accessioning workflow.
