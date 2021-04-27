data "template_file" "container_definitions" {
  template = "${file(var.template-file-path)}"
}