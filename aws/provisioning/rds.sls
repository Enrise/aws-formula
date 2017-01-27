# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/rds.sls" as rds %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:rds') %}

## Create RDS instances
{%- for hostname, details in config.get('instances', {}).iteritems() %}
{{ rds.create_instance(hostname, details, security) }}
{%- endfor %}
