# littleobi-rehl
This will track init script to setup RedHat
curl -o wazuh-agent-4.9.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.9.0-1.x86_64.rpm && sudo WAZUH_MANAGER='10.43.1.36' WAZUH_MANAGER_PORT='1514' WAZUH_REGISTRATION_PORT='1515' WAZUH_REGISTRATION_SERVER='10.203.132.198'  WAZUH_REGISTRATION_PASSWORD=$'password' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='Dragondenv1' rpm -ihv wazuh-agent-4.9.0-1.x86_64.rpm


