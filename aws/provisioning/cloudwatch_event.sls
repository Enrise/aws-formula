# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/cloudwatch_event.sls" as cloudwatch_event %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:cloudwatch_event') %}

## Create Cloudwatch Events
{%- for name, details in config.get('events', {}).iteritems() %}
{{ cloudwatch_event.create_event(name, details, security) }}
{%- endfor %}
