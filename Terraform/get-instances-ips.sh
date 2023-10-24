#!/bin/bash

# Install AWS CLI if not already installed (Uncomment the following line if needed)
# pip install awscli

# Configure your AWS CLI with the appropriate credentials
# aws configure

# Get a list of all running EC2 instances
instance_ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text)

# Loop through the instance IDs and retrieve their names and public IP addresses
for instance_id in $instance_ids; do
    instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" "Name=key,Values=Name" --query "Tags[0].Value" --output text)
    public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[].Instances[].PublicIpAddress" --output text)

    echo "Instance Name: $instance_name"
    echo "Public IP: $public_ip"
    echo
done

# Retrieve the DNS name of the Elastic Load Balancer
elb_dns_name=$(aws elb describe-load-balancers --query "LoadBalancerDescriptions"[0]."DNSName" --output text)

echo "Elastic Load Balancer DNS Name: $elb_dns_name"
