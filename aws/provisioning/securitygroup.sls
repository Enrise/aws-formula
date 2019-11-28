# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/securitygroup.sls" as securitygroup %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:securitygroup') %}

## Create Securitygroups
{%- for name, details in config.get('groups', {}).items() %}
{{ securitygroup.create_group(name, details, security) }}
{%- endfor %}
