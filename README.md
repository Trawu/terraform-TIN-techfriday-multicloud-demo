# terraform-multicloud-demo
This is a simple terraform demo with OpenStack, AWS and Upcloud providers. This demo is provided as is and if you are using it in production you are a dummy. Also please note that this is not optimal way to use Terraform, this repository was created to test power of Terraform, not as a template for your project.

OpenStack provider requires following settings to be set:
```bash
export OS_AUTH_URL="<Your Openstack identity/keystone url>"
export OS_REGION_NAME="<Your region>"
export OS_PROJECT_ID="<Your OpenStack Project ID>"
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
terraform init
terraform plan
terraform apply
```
And destroy created infrastructure:

```bash
terraform destroy
```
