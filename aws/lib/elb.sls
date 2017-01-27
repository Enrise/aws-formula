## Library file for all ELB operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_instance(name, details, securityDetails) %}
aws_elb_{{ name }}:
  boto_elb.present:
    - name: {{ name }}
    {{ utils.sls_flatten(details, ['instances'])|indent(4) }}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
    - region: {{ details['region'] if 'region' in details else 'eu-west-1' }}

{% if 'instances' in details %}
# Add instances to ELB
aws_elb_{{ name }}_instances:
  boto_elb.register_instances:
    - name: {{ name }}
    - instances:
    {% for instance in details.get('instances') %}
      - {{ instance }}
    {%- endfor %}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
    - region: {{ details['region'] if 'region' in details else 'eu-west-1' }}
    - require:
      - boto_elb: aws_elb_{{ name }}
{%- endif %}
{%- endmacro %}
