write_files:
  - path: /opt/jfrog/artifactory/var/etc/createSystemYaml.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND_USERNAME=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_username_param_name})
      AWSCLI_COMMAND_PASSWORD=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${db_password_param_name})      
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/system.yaml
      ## @formatter:off
      ## ARTIFACTORY SYSTEM CONFIGURATION FILE 
      configVersion: 1
      shared:
          security:
              masterKeyFile: "/opt/jfrog/artifactory/var/etc/security/master.key"
          node:
              ip: 0.0.0.0
          database:
              type: postgresql
              driver: org.postgresql.Driver
              url: "jdbc:postgresql://${db_fqdn}/${service}"
              username: $${AWSCLI_COMMAND_USERNAME}
              password: $${AWSCLI_COMMAND_PASSWORD}
          script:
              serviceStartTimeout: 120
      EOF
