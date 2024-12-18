# terraform-mirantis-mke4-vsphere

## Prerequisites

1. Python version 3 needs to be installed on the machine, where TF will be executed
2. `mkectl` installed (see [MKE4 docs](https://mirantis.github.io/mke-docs/docs/getting-started/install-mke-cli/) for details)

## Quickstart

1. Make a copy of `terraform.tfvars.example` and name it `terraform.tfvars`
2. Set vars according to your env in `terraform.tfvars`
3. Execute:
```
terraform apply
terraform output -raw mkectl_config > mke4.yaml
mkectl apply --file mke4.yaml
```

4. Set `<external_address>` variable to the one that you used in tfvars file and execute the following command (if `external_address` was an IP address, not DN):
```
kubectl patch certificate -n mke mke-ingress-cert --kubeconfig ~/.mke/mke.kubeconf --type='json' -p '[{"op":"add","path":"/spec/ipAddresses/-","value":"<external_address>"}]'
```
