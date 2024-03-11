write_files:
  - path: /opt/jfrog/artifactory/var/etc/artifactory/createLic.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${artifactory_license_param_name})
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/artifactory/artifactory.lic
      $${AWSCLI_COMMAND}
      EOF
