#!/bin/bash

IP=$(terraform output -raw ip)
ssh-keygen -R $IP
ssh -i ~/.ssh/gcp ubuntu@$IP
