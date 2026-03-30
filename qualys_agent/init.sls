{%- set default_sources = {'module' : 'qualys_agent', 'pillar' : True, 'grains' : ['os_family']} %}
{%- from "./defaults/load_config.jinja" import config as qualys_agent with context %}

{% if qualys_agent.use is defined %}

{% if qualys_agent.use | to_bool %}

{{ qualys_agent.package_name }}:
  pkg.installed:
  {% if qualys_agent.package_file is defined %}
    - sources:
      - {{ qualys_agent.package_name }}: {{ qualys_agent.package_file }}
  {% endif %}
  - required_in:
    - service: qualys_agent_service

qualys_cloud_agent_install:
  cmd.run:
    - name: {{ qualys_agent.path_to_qualys_cloud_agent }} ActivationId={{ qualys_agent.activation_id }} CustomerId={{ qualys_agent.customer_id }}
    - onchanges:
      - pkg: {{ qualys_agent.package_name }}
    - require:
      - pkg: {{ qualys_agent.package_name }}
      
qualys_agent_service_stop:
  service.dead:
    - name: {{ qualys_agent.service_name }}
    - onchanges:
      - qualys_cloud_agent_install
    - require:
      - qualys_cloud_agent_install
    - required_in:
      - service: qualys_agent_service

qualys_agent_service:
  service.running:
    - name: {{ qualys_agent.service_name }}
    - enable: True

{% else %}

qualys_agent_service:
  service.stopped:
    - name: {{ qualys_agent.service_name }}
    - enable: False

{{ qualys_agent.package_name }}:
  pkg.removed:
    - require:
      - qualys_agent_service

{% endif %}

{% endif %}