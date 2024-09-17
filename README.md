# singlehost-ec2-torero

## Running Plan

To run the plan, you'll need to make sure you have the correct permissions in EC2.  Also, set the variable instance-key-name to the name of the key pair that you'd like to use

```
opentofu apply -auto-approve\
--var instance-key-name=name_of_a_key_in_ec2\
--var aws-access-key=your_aws_key\
--var aws-secret-key=your_aws_secret
```

```
opentofu destroy -auto-approve\
--var instance-key-name=name_of_a_key_in_ec2\
--var aws-access-key=your_aws_key\
--var aws-secret-key=your_aws_secret
```

## Using torero

First grab the torero-import.json file however you want.

```
torero db import torero-import.json
torero run opentofu-plan torero-in-EC2\
--set aws-access-key=some_key\
--set aws-secret-key=some_secret\
--set instance-key-name=mykey-name-in-ec2\
--state-out=./tf.json
```

Then to delete:

```
torero run opentofu-plan destroy torero-in-EC2\
--set aws-access-key=some_key\
--set aws-secret-key=some_secret\
--set instance-key-name=mykey-name-in-ec2\
--state @./tf.json
```
