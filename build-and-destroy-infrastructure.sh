#!/usr/bin/env sh

set -e

# Create remote state
cd terraform/__remote_state__
terraform init
terraform plan -out plan
terraform apply plan
rm plan
cd -

# create global resources
cd terraform/global
terraform init
terraform plan -out plan
terraform apply plan
rm plan
cd -

# build lambdas
./gradlew build

# upload all the artifacts
for project in upload-signer pdf-renderer
do
  openssl dgst -sha256 -binary $project/build/distributions/$project.zip | openssl enc -base64 > $project/build/distributions/$project.zip.base64sha256
  aws s3 cp $project/build/distributions/$project.zip s3://pdf-rendering-lambda-with-terraform-example-lambda-artifacts/$project.zip
  aws s3 cp $project/build/distributions/$project.zip.base64sha256 s3://pdf-rendering-lambda-with-terraform-example-lambda-artifacts/$project.zip.base64sha256
done


# Create dev
cd terraform/dev
terraform init
terraform plan -out plan
terraform apply plan
rm plan
cd -

### Wait before starting to destroy
echo "Press enter to destroy again, else CTRL+C"
read WAIT_FOR_INPUT

### destroy everything from here on!!!
# destroy global resources
cd terraform/global
terraform init
terraform plan -destroy -out plan
terraform apply plan
rm plan
cd -

# Just destroy the remote state here as well
cd terraform/__remote_state__
terraform init
sed 's/force_destroy = false/force_destroy = true/;s/prevent_destroy = true/prevent_destroy = false/' remote-state.tf > remote-state.tf.tmp
mv remote-state.tf.tmp remote-state.tf
terraform plan -out plan
terraform apply plan
terraform plan -destroy -out plan
terraform apply plan
rm plan
sed 's/force_destroy = true/force_destroy = false/;s/prevent_destroy = false/prevent_destroy = true/' remote-state.tf > remote-state.tf.tmp
mv remote-state.tf.tmp remote-state.tf
cd -
