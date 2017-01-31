## Library file for all IAM operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_user(name, details, securityDetails) %}
aws_iam_user_{{ name }}:
  boto_iam.user_present:
    - name: {{ name }}
    {{ utils.sls_flatten(details, ['api_access'])|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}

{%- if 'api_access' in details and details['api_access'] %}
# Generate AWS access details
aws_iam_user_{{ name }}_keys:
  boto_iam.keys_present:
    - name: {{ name }}
    - number: 2
    - save_dir: /root
{%- endif %}
{%- endmacro %}

# Ensure the IAM Group is available
{% macro create_group(name, details, securityDetails) %}
aws_iam_group_{{ name }}:
  boto_iam.group_present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}

# Ensure the IAM Policy
{% macro create_policy(name, details, securityDetails) %}
aws_iam_policy_{{ name }}:
  boto_iam.policy_present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}

# Ensure the IAM Certificate is available
{% macro create_certificate(name, details, securityDetails) %}
aws_iam_certificate_{{ name }}:
  boto_iam.cert_present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}
