# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/elb.sls" as elb %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:elb') %}

## Create ELB
{%- for name, details in config.get('loadbalancers', {}).items() %}
{{ elb.create_instance(name, details, security) }}
{%- endfor %}
