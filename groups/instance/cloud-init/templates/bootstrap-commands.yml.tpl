runcmd:
  - systemctl enable artifactory
  - systemctl start artifactory
  - export token="${access_token}"
  - curl -H "Authorization: Bearer $token " -XPOST "http://${dns_name}:8082/access/api/v1/tokens" -d  '{"description" : "${token_description}", "token_id" : "${token_id}", "scope" : "applied-permissions/admin", "token_type" : "access_token", "include_reference_token" : "true"}' -H "Content-type: application/json"

