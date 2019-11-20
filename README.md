# Create Kubernetes Cluster using KOPS

## Create VPC
1. **Update `variable.tf` as needed**

1.  **terraform plan**

    ```
    cd create-vpc
    make plan
    ```
1. **terraform apply**
    ```
    make apply
    ```
* Notes: 
    We are using s3 bucket `useast1.dev.stem.com` to store terraform statefile including state data of this bucket itself.  It's tricky to create at the first time, since it is catch22 situation. Encourage you to have seperate bucket.

    ```
    $ cat backend.tfvars 
    # s3 terraform state variables
    bucket = "useast1.dev.stem.com"
    # dynamodb_table = "terraform-state"
   $
   ```
## Create K8s Cluster

1. **make k8s-init**
   
   ```
   cd testsg.useast1.dev.stem.com
   make cluster.yaml
   make k8s-init
   ```

1. **make kops-export**
    ```
    cd testsg.useast1.dev.stem.com
    make kops-export
    ```
## Verify cluster

    
    kubectl get nodes
    