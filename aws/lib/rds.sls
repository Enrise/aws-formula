## Library file for all RDS operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the instance with the given name is created
{% macro create_instance(name, details, securityDetails) %}
aws_rds_instance_{{ name }}:
  boto_rds.present:
    - name: {{ name }}
    {{ utils.sls_list(details,['tags'])|indent(4) }}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
    - region: {{ details.get('region', 'eu-west-1') }}

{%- if 'tags' in details %}
# Tags are currently unavailable see https://github.com/saltstack/salt/issues/38936
warn_tags_{{ name }}:
  test.show_notification:
    - name: "Unable to set RDS Instance tags for '{{ name }}'"
    - text: |
          Assigning tags to RDS instance is not possible. Please correct this by hand in the AWS Console.
          For more details see https://github.com/saltstack/salt/issues/38936
    - require:
      - boto_rds: aws_rds_instance_{{ name }}
{%- endif %}
{%- endmacro %}
