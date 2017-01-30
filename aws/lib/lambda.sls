## Library file for all Lambda operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the given function is created
{% macro create_function(name, details, securityDetails) -%}
{%- if 'ZipFile' in details and 'salt://' in details.get('ZipFile') %}
# A Zipfile is specified and uses the salt:// fileserver, download it.
# Requested as a Salt core feature: https://github.com/saltstack/salt/issues/38986
{%- set zipFile = details.get('ZipFile').split('/')|last %}
{%- set zipPath = '/var/cache/salt/minion/extrn_files/' ~ zipFile %}
aws_lambda_function_{{name}}_file:
  file.managed:
    - name: {{ zipPath }}
    - source: {{ details.get('ZipFile') }}
    - require_in:
      - boto_lambda: aws_lambda_function_{{ name }}
# Ensure the lambda function is created with the new local file
{%- do details.update({'ZipFile': zipPath}) %}
{%- endif %}

aws_lambda_function_{{ name }}:
  boto_lambda.function_present:
    {{ utils.sls_list(details,['Triggers'])|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}

# Create CloudWatch triggers in case it has been specified underneath the Lambda
{%- if 'Triggers' in details %}
{%- import 'aws/lib/cloudwatch_event.sls' as cloudwatch_event %}
{%- for trigger in details.get('Triggers') %}
{%- if not 'Targets' in trigger %}
{%- set arn = "arn:aws:lambda:" ~ securityDetails.get('region', 'eu-west-1') ~ ":" ~ securityDetails.get('accountid') ~ ":function:" ~ name %}
{%- do trigger.update({'Targets': [{'Id': name, 'Arn': arn.encode('utf8') }]}) %}
{%- endif %}
{%- if not 'Description' in trigger and 'Description' in details %}
{%- do trigger.update({'Description': details.get('Description')}) %}
{%- endif %}
{{ cloudwatch_event.create_event(name, trigger, securityDetails) }}
    - require:
      - boto_lambda: aws_lambda_function_{{ name }}
{%- endfor %}
{%- endif %}

{%- endmacro %}
