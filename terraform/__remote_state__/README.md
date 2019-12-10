# Terraform remote state
This directory only handles the configuration of the remote-state bucket for
the terraform-project.

**This configuration is managed manually without any CI/CD interaction to avoid
problems!** 

In particular the state for this configuration is handled completely outside of
any specific environment and is stored in other infrastructure. e.g. a
usb-stick.

**Be careful whatever you do here**
