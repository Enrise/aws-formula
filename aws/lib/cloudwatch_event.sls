## Library file for all Cloudwatch Event operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_event(name, details, securityDetails) %}
aws_cloudwatch_event_{{ name }}:
  boto_cloudwatch_event.present:
    - Name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
    - region: {{ details['region'] if 'region' in details else 'eu-west-1' }}
{%- endmacro %}
