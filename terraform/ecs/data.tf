data "template_file" "container_definitions" {
  template = file(var.template_file_path)
  vars = {
    container_name       = var.container_name
    container_repository = var.container_repository
    container_tag        = var.container_tag
  }
}
