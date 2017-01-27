# Various functions for readability.

# Create a list based on a dictionary
{%- macro sls_list(dict, filter=[]) %}
{%- for key, value in dict.items() %}
{%- if key not in filter %}
- {{ key }}: {{ value|json() }}
{%- endif %}
{%- endfor %}
{%- endmacro %}

# Create a dictionary based on a dictionary
{%- macro sls_dict(dict, filter=[]) %}
{%- for key, value in dict.items() %}
{%- if key not in filter %}
{{ key }}: {{ value|json() }}
{%- endif %}
{%- endfor %}
{%- endmacro %}

{%- macro sls_raw(data) %}
{{ data|json() }}
{%- endmacro %}

{%- macro sls_flatten(data, filter=[]) %}
{%- for section, values in data.items() %}
{%- if section not in filter %}
- {{ section }}: {{ data.get(section) }}
{%- endif %}
{%- endfor %}
{%- endmacro %}

# Serializes dicts into sequenced data
{%- macro serialize(data) -%}
    {%- if data is mapping -%}
        {%- set ret = [] -%}
        {%- for key, value in data.items() -%}
            {%- set value = serialize(value)|load_json() -%}
            {%- do ret.append({key: value}) -%}
        {%- endfor -%}
    {%- elif data is iterable and data is not string -%}
        {%- set ret = [] -%}
        {%- for value in data -%}
            {%- set value = serialize(value)|load_json() -%}
            {%- do ret.append(value) -%}
        {%- endfor -%}
    {%- else -%}
        {% set ret = data %}
    {%- endif -%}

    {{ ret|json() }}
{%- endmacro -%}
