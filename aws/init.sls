# This formula uses Boto3 to communicate, therefor we need to install the dependencies
formula_dependencies:
  pkg.installed:
    - name: python-pip
  pip.installed:
    - name: boto3
    - require:
      - pkg: python-pip

# @todo: do we want to provision all services by default, or let the user include them manually as desired?
