data "template_file" "container_definitions" {
  template = "${file(var.template-file-path)}"
  vars = {
    container_repository = var.container_repository
    container_tag = var.container_tag
  }
}