# terraform-TIN-techfriday-multicloud-demo
This is a simple terraform demo for Telia Inmics-Nebula Cloud9 (OpenStack). This demo is provided as is and if you are using it in production you are a dummy. Also please note that this is not optimal way to use Terrafrom, this repository was created to demonstrate power of Terraform, not as a template for your project.

OpenStack provider requires following settings to be set:
```bash
export OS_AUTH_URL="https://identity.fi-1.nebulacloud.fi:5000/v3"
export OS_REGION_NAME="fi-1"
export OS_USERNAME="<You Username>"
export OS_PASSWORD="<Your Password>"
export OS_USER_DOMAIN_NAME="default"
export OS_IDENTITY_API_VERSION="3"
```
When using Openstack Provider you can also use EC2 credentials if you know how.

AWS provider requires following settings to be set:

```bash
export AWS_ACCESS_KEY_ID="<Your Access Key ID>"
export AWS_SECRET_ACCESS_KEY="<Your access Key>"
export AWS_DEFAULT_REGION="<Your region>"
```

UpCloud provider requires following settings to be set:
```bash
export UPCLOUD_USERNAME="<Your username>"
export UPCLOUD_PASSWORD="<Your password>"
```
You can use Terraform from bash CLI following way:

```bash
terraform plan
terraform apply
```
And destroy created infrastructure:

```bash
terraform destroy
```
