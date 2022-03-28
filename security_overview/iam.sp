benchmark "iam" {
  title       = "Identity and Access Management"
  description = "Once your Snowflake account is accessible, the next step in gaining access to Snowflake is to authenticate the user. Users must be created in Snowflake prior to any access. Once the user is authenticated, a session is created with roles used to authorize access in Snowflake. \nThis section covers best practices for: \n- Managing users and roles\n- Authentication and single sign-on\n- Sessions\n- Object-level access control (authorization)\n- Column-level access control\n- Row-level access control"
  children = [
    control.iam_user_has_password,
    control.iam_user_with_buillt_in_duo_mfa,
    control.iam_user_default_role_is_set,
    control.iam_schema_managed_access,
    control.iam_user_accountadmin_role_grants,
    control.iam_user_accountadmin_must_not_be_default_role,
    control.iam_user_with_accountadmin_role_have_email
  ]
}

# https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-use.html#managing-users-with-federated-authentication-enabled
control "iam_user_has_password" {
  title       = "Snowflake recommends to disable Snowflake authentication for all non-administrator users"
  description = "For users who don't require a password in Snowflake, set the password property to null. This will ensure that the password as an authentication method isn't available to those users, and they can't set the password themselves."
  sql         = query.user_has_password.sql
}

control "iam_user_with_buillt_in_duo_mfa" {
  title       = "Snowflake recommends using MFA as it provides an additional layer of security"
  description = "Snowflake supports multi-factor authentication (i.e. MFA) to provide increased login security for users connecting to Snowflake. MFA support is provided as an integrated Snowflake feature, powered by the Duo Securityservice, which is managed completely by Snowflake."
  sql         = query.user_with_buillt_in_duo_mfa.sql
}

control "iam_user_default_role_is_set" {
  title       = "Snowflake recommends the default_role property for the user is set"
  description = "A user's default role determines the role used in the Snowflake sessions initiated by the user; however, this is only a default. Users can change roles within a session at any time. Snowflake recommends that designate a lower-level administrative or custom role as their default."
  sql         = query.user_default_role_is_set.sql
}

# Use managed access schema to centralize grant management
control "iam_schema_managed_access" {
  title       = "Snowflake recommends using managed access schemas to centralize grant management"
  description = "Managed access schemas improve security by locking down privilege management on objects. In regular (i.e. non-managed) schemas, object owners (i.e. a role with the OWNERSHIP privilege on an object) can grant access on their objects to other roles, with the option to further grant those roles the ability to manage object grants. With managed access schemas, object owners lose the ability to make grant decisions. Only the schema owner (i.e. the role with the OWNERSHIP privilege on the schema) or a role with the MANAGE GRANTS privilege can grant privileges on objects in the schema, including future grants, centralizing privilege management."
  sql         = query.schema_managed_access.sql
}

control "iam_user_accountadmin_role_grants" {
  title       = "At least two users must be assigned ACCOUNTADMIN role"
  description = "By default, each account has one user who has been designated as an account administrator (i.e. user granted the system-defined ACCOUNTADMIN role). Snowflake recommend designating at least one other user as an account administrator. This helps ensure that your account always has at least one user who can perform account-level tasks, particularly if one of your account administrators is unable to log in."
  sql         = query.user_accountadmin_role_grant_count.sql
}

control "iam_user_accountadmin_must_not_be_default_role" {
  title       = "ACCOUNTADMIN role must not be set as the default role for users"
  description = "Grant the ACCOUNTADMIN role to the user(s), but do not set this role as their default. Instead, designate a lower-level administrative role (e.g. SYSADMIN) or custom role as their default. This helps prevent account administrators from inadvertently using the ACCOUNTADMIN role to create objects."
  sql         = query.user_accountadmin_must_not_be_default_role.sql
}

control "iam_user_with_accountadmin_role_have_email" {
  title       = "Ensure an email address is specified for users with ACCOUNTADMIN role"
  description = "Snowflake recommendsto associate an actual person's email address to ACCOUNTADMIN users, so that Snowflake Support knows who to contact in an urgent situation."
  sql         = query.user_with_accountadmin_role_have_email.sql
}