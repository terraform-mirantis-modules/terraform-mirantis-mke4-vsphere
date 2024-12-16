# terraform-mirantis-mke4-vsphere

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
kubectl patch certificate -n mke mke-ingress-cert --kubeconfig /Users/rkuzmin/.mke/mke.kubeconf --type='json' -p '[{"op":"add","path":"/spec/ipAddresses/-","value":"<external_address>"}]'
```
