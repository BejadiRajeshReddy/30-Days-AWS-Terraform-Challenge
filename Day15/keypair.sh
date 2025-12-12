#!/bin/bash

# Creating key pair in us-east-1
aws ec2 create-key-pair \
  --key-name vpc-peering-project \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > vpc-peering-primary.pem

# Creating key pair in us-west-2
aws ec2 create-key-pair \
  --key-name vpc-peering-project \
  --region us-west-2 \
  --query 'KeyMaterial' \
  --output text > vpc-peering-secondary.pem

# Set permissions
chmod 400 vpc-peering-*.pem

echo "Keys created successfully!"

#  ./create-keys.sh    Run this command to create the keys

