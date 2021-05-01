resource "aws_key_pair" "mmm" {
  key_name   = "mmm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVzrEB9jq/2jJSbKw+wv3fmP4vRurlAqnc827x3PDE6Nkdkyl++7JGBsG58QI/RAQjN/Z54Zy8l80LNbo3IJoNZAZ+0nALFdzJfORLWx3je69MQ5X6kLRh36PcBNkbxk+/QYaR3LOGOhwMN+GtK/6WNowNxTrg44KPV8wJicu/glqF9xJQn5+1Y4np+orr+TQr6GHlZDhQy7yeVd4XuEK1PAw+60tA53TAEktRB/RuiFb0/FmT7DsHg94txMD3Zvba0xl0SFSbVwdyDHRJrrDTykPnDkNdYj0KwmI2fTklNA1jvCjIFdiTGJBVfBCZDxB/1d/BbH1IbptWNnLl1ToX"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "mmm"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVzrEB9jq/2jJSbKw+wv3fmP4vRurlAqnc827x3PDE6Nkdkyl++7JGBsG58QI/RAQjN/Z54Zy8l80LNbo3IJoNZAZ+0nALFdzJfORLWx3je69MQ5X6kLRh36PcBNkbxk+/QYaR3LOGOhwMN+GtK/6WNowNxTrg44KPV8wJicu/glqF9xJQn5+1Y4np+orr+TQr6GHlZDhQy7yeVd4XuEK1PAw+60tA53TAEktRB/RuiFb0/FmT7DsHg94txMD3Zvba0xl0SFSbVwdyDHRJrrDTykPnDkNdYj0KwmI2fTklNA1jvCjIFdiTGJBVfBCZDxB/1d/BbH1IbptWNnLl1ToX"

}