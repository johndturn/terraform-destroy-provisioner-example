# Terraform Destroy Provisioner Example

In the process of writing some Terraform configs for work, I came across what I believe to be a bug with Terraform 0.11.8. Specifically, the error has to do with `local-exec provisioners` set to run on destroy of the resource. These provisioners appear to not run (at least, when paired with a regular, creation-time `local-exec provisioner`).

This repo is meant to be a basic example reproducing this issue.

## Update!

After working with `@jbardin`, a contributor to Terraform, we've discovered that this issue actually lies in the use of destroy-time provisioners and `terraform taint`. This is a known issue, and can be followed here: https://github.com/hashicorp/terraform/issues/13549#issuecomment-293627472.

## Testing

In order to test this, clone the repo, `cd` into it, and run the following:

**Note**: This assumes that you have valid AWS keys stored correctly on your machine. I.e., you should be able to run the AWS CLI correctly.

```bash
$ terraform init
$ terraform apply # approve the bucket creation
# Taint the resource to force the destruction / re-creation of bucket
$ terraform taint aws_s3_bucket.example-bucket
$ terraform apply # approve the bucket creation
```

## Cleanup

As S3 buckets all share a global namespace, it's important to not keep your infrastructure up and running from this example. Once you've tested please remember to destroy your infrastructure with `terraform destroy`.

### If you Can't Run Terraform Destroy

Then this repo proves a valid issue with Terraform. However, in order to fully kill the bucket and destroy all infrastructure spun up here, you'll need to run the following:

```bash
# Call the pre-destroy script manually
$ BUCKET=example.bucket.1234.56789 sh pre-receipts-bucket.destroy.sh
$ terraform destroy # approve the bucket destruction
```
