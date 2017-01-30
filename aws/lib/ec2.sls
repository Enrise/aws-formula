## Library file for all EC2 operations
{%- import 'aws/lib/utils.sls' as utils %}

# Ensure the given SSH pubkey is available
{% macro add_pubkey(name, key, securityDetails) -%}
aws_ec2_ssh_pubkey_{{ name }}:
   boto_ec2.key_present:
    - name: {{ name }}
    - upload_public: '{{ key }}'
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
{%- endmacro %}

# Ensure the instance with the given name is created
{% macro create_instance(hostname, details, securityDetails) %}
# Create the network interface (ENI)
aws_ec2_instance_{{ hostname }}_nic:
  boto_ec2.eni_present:
    - name: {{ hostname }}
    - subnet_id: {{ details.get('subnet_id') }}
    {%- if 'private_ip_address' in details %}
    - private_ip_address: {{ details.get('private_ip_address') }}
    {%- endif %}
    - description: {{ details.get('nic_description') }}
    - groups: {{ details.get('security_group_ids') }}
    - source_dest_check: {{ details.get('source_dest_check', True) }}
    - allocate_eip: {{ details.get('allocate_eip', False) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}

aws_ec2_instance_{{ hostname }}:
  boto_ec2.instance_present:
    - instance_name: {{ hostname }}
    {{ utils.sls_list(details, ['private_ip_address','subnet_id','allocate_eip','source_dest_check','nic_description'])|replace('%hostname%', hostname)|indent(4) }}
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
    # Attach NIC we just created
    - network_interface_name: {{ hostname }}
    - require:
      # Require the SSH key to be available
      - boto_ec2: aws_ec2_ssh_pubkey_{{ details.get('key_name') }}
      # Require the ENI to be available
      - boto_ec2: aws_ec2_instance_{{ hostname }}_nic

{%- set instance_tags = details.get('tags') %}
{%- set block_device_map = details.get('block_device_map') %}
# Set tags for volumes
aws_ec2_tag_volumes_{{ hostname }}:
  boto_ec2.volumes_tagged:
    - tag_maps:
      {%- for device_name, device_details in block_device_map.iteritems() %}
      - filters:
          instance_name: {{ hostname }}
          attachment.device: {{ device_name }}
        tags:
          {{ utils.sls_dict(instance_tags,{})|replace('%hostname%', hostname)|indent(10) }}
          {{ utils.sls_dict(device_details.get('tags',{}))|replace('%hostname%', hostname)|indent(10) }}
      {%- endfor %}
    - authoritative: False
    {{ utils.addSecurityDetails(securityDetails)|indent(4) }}
    - require:
      - boto_ec2: aws_ec2_instance_{{ hostname }}
{%- endmacro %}
