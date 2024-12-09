write_files:
  - path: ${artifactory_base_path}/var/etc/access/createBootstrap.sh
    permissions: 0750
    content: |
      #!/bin/bash
      AWSCLI_COMMAND=$(${aws_command} --region ${region} --query 'Parameter.Value' --name ${admin_password_param_name})
      cat <<EOF > ${artifactory_base_path}/var/etc/access/bootstrap.creds
      admin@*=$${AWSCLI_COMMAND}
      EOF
      chmod 0600 ${artifactory_base_path}/var/etc/access/bootstrap.creds
      chown ${artifactory_user}:${artifactory_group} ${artifactory_base_path}/var/etc/access/bootstrap.creds
