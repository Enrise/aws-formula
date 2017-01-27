# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/lambda.sls" as lambda %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:lambda') %}

## Create Lambda functions
{%- for name, details in config.get('functions', {}).iteritems() %}
{{ lambda.create_function(name, details, security) }}
{%- endfor %}
