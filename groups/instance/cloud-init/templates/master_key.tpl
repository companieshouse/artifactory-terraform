write_files:
  - path: ${artifactory_base_path}/var/etc/security/createMasterKeyYaml.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_MASTERKEY=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_masterkey_param_name})    
      cat <<EOF > ${artifactory_base_path}/var/etc/security/master.key
      $${AWSCLI_COMMAND_MASTERKEY}
      EOF
      chmod 0640 ${artifactory_base_path}/var/etc/security/master.key
      chown ${artifactory_user}:${artifactory_group} ${artifactory_base_path}/var/etc/security/master.key
