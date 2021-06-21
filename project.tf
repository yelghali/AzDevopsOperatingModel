resource "azuredevops_project" "project" {
  name       = "Test Project"
  description        = "This Project is generated by Terraform Weaaaayyyaa"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"

  features = {
      "testplans" = "disabled"
      "artifacts" = "disabled"
  }
}

