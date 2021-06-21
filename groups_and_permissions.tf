
#reference existing Azure DevOps Group
data "azuredevops_group" "project-readers" {
  project_id = azuredevops_project.project.id
  name       = "Readers"
}

#create new Azure Devops Group
resource "azuredevops_group" "g" {
  scope        = azuredevops_project.project.id
  display_name = "Terraform created AZ Devops Group"
  description  = "Azure Devops Group Created From Terraform"
}

resource "azuredevops_user_entitlement" "user_yaya" {
  principal_name = "yaelghal@microsoft.com"
}


resource "azuredevops_group_membership" "membership" {
  group = azuredevops_group.g.descriptor
  members = [
    azuredevops_user_entitlement.user_yaya.descriptor
  ]
}

#Create Project level permissions for group Readers
resource "azuredevops_project_permissions" "project-perm" {
  project_id  = azuredevops_project.project.id
  principal   = data.azuredevops_group.project-readers.id
  permissions = {
    DELETE              = "Deny"
    EDIT_BUILD_STATUS   = "NotSet"
    WORK_ITEM_MOVE      = "Allow"
    DELETE_TEST_RESULTS = "Deny"
    GENERIC_WRITE = "Deny"
    MANAGE_PROPERTIES = "Deny"
    RENAME = "Allow"

  }
}

#Pipeline Permissions
resource "azuredevops_build_definition_permissions" "readers_group_permissions" {
    project_id  = azuredevops_project.project.id
    principal   = data.azuredevops_group.project-readers.id

    build_definition_id = azuredevops_build_definition.buildwithgroup.id

    permissions = {
      ViewBuilds       = "Allow"
      EditBuildQuality = "Deny"
      DeleteBuilds     = "Deny"
      StopBuilds       = "Allow"
      DestroyBuilds       = "Allow"
    }
}


#Pipeline Permissions
resource "azuredevops_build_definition_permissions" "g_group_permissions" {
    project_id  = azuredevops_project.project.id
    principal   = azuredevops_group.g.id

    build_definition_id = azuredevops_build_definition.buildwithgroup.id

    permissions = {
      ViewBuilds       = "Allow"
      EditBuildQuality = "Deny"
      DeleteBuilds     = "Deny"
      StopBuilds       = "Deny"
      DestroyBuilds       = "Deny"
    }
}



#Reference existing AzdO Group (created by default)
data "azuredevops_group" "project-contributors" {
  project_id = azuredevops_project.project.id
  name       = "Contributors"
}

#Reference existing AzdO Group (created by default)
data "azuredevops_group" "project-administrators" {
  project_id = azuredevops_project.project.id
  name       = "Project administrators"
}

#Git Repo permissions, for AZDO Group Readers
resource "azuredevops_git_permissions" "project-git-root-permissions" {
  project_id  = azuredevops_project.project.id
  principal   = data.azuredevops_group.project-readers.id
  permissions = {
    CreateRepository = "Deny"
    DeleteRepository = "Deny"
    RenameRepository = "NotSet"
  }
}

#Git Repo permissions, for AZDO Group Admins
resource "azuredevops_git_permissions" "project-git-repo-permissions" {
  project_id  = azuredevops_project.project.id
  repository_id = azuredevops_git_repository.repo.id
  principal     = data.azuredevops_group.project-administrators.id
  permissions   = {
    RemoveOthersLocks = "Allow"
    ManagePermissions = "Deny"
    CreateTag         = "Allow"
    CreateBranch      = "Allow"
  }
}
