resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.project.id
  name         = "my-variable-group"
  allow_access = true
 
  variable {
    name  = "var1"
    value = "value1"
  }
 
  variable {
    name  = "var2"
    value = "value2"
  }
}
 
resource "azuredevops_build_definition" "buildwithgroup" {
  project_id = azuredevops_project.project.id
  name       = "Sample Build Pipeline with VarGroup"
 
  ci_trigger {
    use_yaml = true
  }
 
  variable_groups = [
    azuredevops_variable_group.vars.id
  ]
 
  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repo.id
    branch_name = azuredevops_git_repository.repo.default_branch
    yml_path    = "azure-pipelines.yml"
  }
}
