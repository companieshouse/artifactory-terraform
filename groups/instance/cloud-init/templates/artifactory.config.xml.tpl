#cloud-config
write_files:
  - path: /opt/jfrog/artifactory/var/etc/artifactory/artifactory.config.xml
    content: |
      <?xml version="1.0" encoding="UTF-8"?>
      <config xmlns="http://artifactory.jfrog.org/xsd/3.0.0">
        <database>
          <type>postgresql</type>
          <driver>org.postgresql.Driver</driver>
          <url>jdbc:postgresql://${db_fqdn}:${db_port}/${db_name}</url>
          <username>${db_username}</username>
          <password>${db_password}</password>
        </database>
        <security>
          <ldapSettings>
            <ldapSetting>
              <key>${ldapSetting_id}</key>
              <enabled>true</enabled>
              <ldapUrl>${ldapSetting_ldapUrl}</ldapUrl>
              <userDnPattern>${ldapSetting_userDnPattern}</userDnPattern>
              <searchFilter>${ldapSetting_searchFilter}</searchFilter>
              <searchBase>${ldapSetting_searchBase}</searchBase>
              <managerDn>${ldapSetting_managerDn}</managerDn>
              <managerPassword>"${ldapSetting_managerPassword}"</managerPassword>
              <emailAttribute>${ldapSetting_emailAttribute}</emailAttribute>
              <allowUserToAccessProfile>${ldapSetting_allowUserToAccessProfile}</allowUserToAccessProfile>
              <descriptionAttribute>${ldapSetting_descriptionAttribute}</descriptionAttribute>
              
              <!-- LDAP group settings -->
              <groupSettings>
                <enabled>true</enabled>
                <groupBaseDn>${ldapGroupSettings_groupBaseDn}</groupBaseDn>
                <groupNameAttribute>${ldapGroupSettings_groupNameAttribute}</groupNameAttribute>
                <groupMemberAttribute>${ldapGroupSettings_groupMemberAttribute}</groupMemberAttribute>
                <groupFilter>${ldapGroupSettings_filter}</groupFilter>
                <subTree>${ldapGroupSettings_subTree}</subTree>
                <descriptionAttribute>${ldapGroupSettings_descriptionAttribute}</descriptionAttribute>
                <strategy>${ldapGroupSettings_strategy}</strategy>
              </groupSettings>
            </ldapSetting>
          </ldapSettings>
        </security>
      </config>
