# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/iam.sls" as iam %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:iam') %}

## Create IAM users
{%- for name, details in config.get('users', {}).iteritems() %}
{{ iam.create_user(name, details, security) }}
{%- endfor %}

## Create IAM groups
{%- for name, details in config.get('groups', {}).iteritems() %}
{{ iam.create_group(name, details, security) }}
{%- endfor %}

## Create IAM Policies
{%- for name, details in config.get('policies', {}).iteritems() %}
{{ iam.create_policy(name, details, security) }}
{%- endfor %}

## Create IAM Certificates
{%- for name, details in config.get('certificates', {}).iteritems() %}
{{ iam.create_certificate(name, details, security) }}
{%- endfor %}
