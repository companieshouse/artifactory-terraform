write_files:
  - path: ${artifactory_base_path}/var/etc/artifactory/createLic.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${artifactory_license_param_name})
      cat <<EOF > ${artifactory_base_path}/var/etc/artifactory/artifactory.lic
      $${AWSCLI_COMMAND}
      EOF
      chmod 0640 ${artifactory_base_path}/var/etc/artifactory/artifactory.lic
      chown ${artifactory_user}:${artifactory_group} ${artifactory_base_path}/var/etc/artifactory/artifactory.lic
