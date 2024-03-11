write_files:
  - path: /opt/jfrog/artifactory/var/etc/security/createMasterKeyYaml.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_MASTERKEY=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_masterkey_param_name})    
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/security/master.key
      $${AWSCLI_COMMAND_MASTERKEY}
      EOF
