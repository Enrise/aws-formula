## Library file for all Securitygroup operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the security group with the given name is created
{% macro create_group(name, details, securityDetails) %}

{%- if 'tags' in details %}
{%- set tags = details.get('tags') %}

{% if 'Name' not in tags %}
# Name tag is missing, append it based on the group name
{%- do tags.update({'Name': name}) %}
{%- endif %}

{% if 'ProvisionedBy' not in tags %}
# ProvisionedBy tag is missing, append it based on the group name
{%- do tags.update({'ProvisionedBy': 'Salt'}) %}
{%- endif %}

# Update the tags list
{%- do details.update({'tags': tags}) %}

{%- endif %}

aws_cloudwatch_event_{{ name }}:
  boto_secgroup.present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}
