# Archived and unmaintained

This is an old repository that is no longer used or maintained. We advice to no longer use this repository.

## Original README can be found below:

# aws-formula

This formula allows easy management of AWS using pillar data.
Most `boto_*` functions offer support for loading pillar directly, however this requires a massive set of references to particular pillars.
Because this is impractical we've created this aws-formula to make life a little easier.

On top of that, it adds some functionality that is lacking in the `boto_*` modules of Salt (e.g. dealing with `salt://` files in Lambda)

## Compatibility

There are no specific OS requirements/limitations other than being able to run
Salt-minion

## Contributing

Pull requests are more than welcome.

## Usage

Include "aws" in your project for the base setup (dependencies).
For provioning specific systems you can select which states you require.

## Supported AWS Functions
The following AWS functions have (basic) implementations:
* Cloudwatch Event's
* EC2
* ELB
* IAM Role
* Lambda (with integration to Cloudwatch for Triggers)
* RDS
* S3
* Security Groups

## Configuration

The included pillar.example shows the available options.

## Todo

- [ ] Add support for VPC
- [ ] Remove workarounds due to upstream module bugs/limitations
