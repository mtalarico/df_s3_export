# Data Federation S3 Bucket Export

## Prerequistes
you must have an AWS IAM role configured to your Atlas project for this work out of the box. If not, either edit the terraform script to direct it to [a cloud_provider_access resource](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/data-sources/cloud_provider_access) or manually find it via the [Cloud Provider Access Roles Admin API Endpoint](https://www.mongodb.com/docs/atlas/reference/api-resources-spec/v2/#tag/Cloud-Provider-Access/operation/listCloudProviderAccessRoles) or the [Atlas CLI](https://www.mongodb.com/docs/atlas/cli/stable/) (using `atlas cloudProviders accessRoles list`)

you must also set the variables in `terraform.tfvars.template.json`/`variables.tf`

## Run
```
terraform init
terraform plan
terraform apply
```

## Aggregation
the following is the most basic aggregation; however, the export `$out` can get *much* more complex, see [the $out docs](https://www.mongodb.com/docs/atlas/data-federation/supported-unsupported/pipeline/out/#simple-string-example) for more details.

```
db.getSiblingDB("support-center").getCollection("audit").aggregate([
    {
        $out: {
            s3: {
                bucket: "bucket_name",
                filename: "exporttest",
                format: {
                    name: "json"
                }
            }
        }
    }
])
```

**Disclaimer: This code is not intended to be production-code, rather an example of how terraform can be used to configure Atlas. Please test thoroughly and use at your own risk**
