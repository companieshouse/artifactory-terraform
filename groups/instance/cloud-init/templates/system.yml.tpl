write_files:
  - path: /opt/jfrog/artifactory/var/etc/system.yaml
    append: false
    content: |
      configVersion: 1
      shared:
        security:
          ldapSettings:
            ${ldapSetting_id}:
              emailAttribute: ${ldapSetting_emailAttribute}
              ldapPoisoningProtection: true
              ldapUrl: ${ldapSetting_ldapUrl}
              search:
                managerDn: ${ldapSetting_managerDn}
                managerPassword: ${ldapSetting_managerPassword}
                searchBase: ${ldapSetting_searchBase}
                searchFilter: ${ldapSetting_searchFilter}
                searchSubTree: ${ldapSetting_searchSubTree}
              userDnPattern: ${ldapSetting_userDnPattern}
              allowUserToAccessProfile: ${ldapSetting_allowUserToAccessProfile}
              autoCreateUser: true
              enabled: true
          ldapGroupSettings:
            admin:
              descriptionAttribute: ${ldapGroupSettings_descriptionAttribute}
              enabledLdap: ${ldapSetting_id}
              filter: ${ldapGroupSettings_filter}
              groupBaseDn: ${ldapGroupSettings_groupBaseDn}
              groupMemberAttribute: ${ldapGroupSettings_groupMemberAttribute}
              groupNameAttribute: ${ldapGroupSettings_groupNameAttribute}
              strategy: ${ldapGroupSettings_strategy}
              subTree: ${ldapGroupSettings_subTree}
          exposeApplicationHeaders: false
        database:
          type: postgresql
          driver: org.postgresql.Driver
          url: jdbc:postgresql://${db_fqdn}/artifactory
          username: ${db_username}
          password: ${db_password}
      access:
        ## Skip creating default admin user on startup
        startUpSkipDefaultAdmin: true
