# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/iam_role.sls" as iam %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:iam_role') %}

## Create IAM Role
{%- for name, details in config.get('roles', {}).iteritems() %}
{{ iam.create_role(name, details, security) }}
{%- endfor %}
