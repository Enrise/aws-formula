## Library file for all S3 operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the given bucket is created
{% macro create_bucket(name, details, securityDetails) -%}
aws_s3_bucket_{{ name }}:
  boto_s3_bucket.present:
    - Bucket: {{ name }}
    {{ utils.sls_flatten(details)|indent(4) }}
    - region: {{ details.get('region', 'eu-west-1') }}
    - keyid: {{ securityDetails.get('keyid') }}
    - key: {{ securityDetails.get('key') }}
{%- endmacro %}
