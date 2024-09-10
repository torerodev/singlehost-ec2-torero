# singlehost-ec2-torero

## Running Plan

To run the plan, you'll need to make sure you have the correct permissions in EC2.  Also, set the variable instance-key-name to the name of the key pair that you'd like to use

```
terraform apply --var instance-key-name=name_of_a_key_in_ec2 -auto-approve
```

```
terraform destroy -auto-approve
```
