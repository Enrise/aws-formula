## Library file for all ELB operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_instance(name, details, securityDetails) %}
aws_elb_{{ name }}:
  boto_elb.present:
    - name: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}
