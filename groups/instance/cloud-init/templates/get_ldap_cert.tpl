write_files:
  - path: /opt/jfrog/${service}/var/etc/security/keys/trusted/get-ldap-certificate.sh
    owner: root:root
    permissions: 0744
    content: |
      #!/bin/bash

      set -e

      echo -n | openssl s_client -connect ${artifactory_auth_ldaps_host}:636 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /opt/jfrog/${service}/var/etc/security/keys/trusted/ldap-certificate.pem
      chmod 0400 /opt/jfrog/${service}/var/etc/security/keys/trusted/ldap-certificate.pem
      chown ${service}:${service} /opt/jfrog/${service}/var/etc/security/keys/trusted/ldap-certificate.pem
