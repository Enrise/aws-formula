## Library file for all IAM Role operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_role(name, details, securityDetails) %}
aws_iam_role_{{ name }}:
  boto_iam_role.present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
    - region: {{ details['region'] if 'region' in details else 'eu-west-1' }}
{%- endmacro %}
