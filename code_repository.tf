resource "azuredevops_git_repository" "repo" {
  project_id           = azuredevops_project.project.id
  name                 = "Sample Import from Azure MLOps Git Repo"
  initialization {
    init_type = "Import"
    source_type = "Git"
    source_url = "https://github.com/microsoft/MLOps.git"
  }
}
