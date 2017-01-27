# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/ec2.sls" as ec2 %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:ec2') %}

## Create SSH keypairs
{%- for name, key in config.get('ssh_keys', []).iteritems() %}
{{ ec2.add_pubkey(name, key, security) }}
{%- endfor %}

## Create EC2 instances (with volumes and ENI's)
{%- for hostname, details in config.get('instances', {}).iteritems() %}
{{ ec2.create_instance(hostname, details, security) }}
{%- endfor %}
