write_files:
  - path: /opt/jfrog/artifactory/var/etc/access/createBootstrap.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${admin_password_param_name})
      cat <<EOF >> /opt/jfrog/artifactory/var/etc/access/bootstrap.creds
      admin@*=$${AWSCLI_COMMAND}
      EOF
