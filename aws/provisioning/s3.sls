# State module for running the provisioning based on the pillar configuration
{% import "aws/lib/s3.sls" as s3 %}
{%- set security = salt['pillar.get']('aws:security') %}
{%- set config = salt['pillar.get']('aws:services:s3') %}

## Create S3 Buckets
{%- for bucket_name, bucket_details in config.get('buckets', {}).iteritems() %}
{{ s3.create_bucket(bucket_name, bucket_details, security) }}
{%- endfor %}
