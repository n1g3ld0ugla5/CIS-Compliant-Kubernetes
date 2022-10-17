#!/usr/bin/env bash
curl https://docs.projectcalico.org/manifests/calico.yaml -O

sed -i 's/# - name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/g' calico.yaml
sed -i 's/#   value: "192.168.0.0\/16"/  value: "192.168.0.0\/20"/g' calico.yaml

cat calico.yaml | grep CALICO_IPV4POOL_CIDR -A1

kubectl apply -f ./calico.yaml
kubectl create ns cis-benchmarks

# Install Kube-Bench
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml -n cis-benchmarks
kubectl apply -f job.yaml
kubectl logs -l "app=kube-bench"

# Kube-Bench Job Node
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-node.yaml -n cis-benchmarks
kubectl apply -f job.yaml

# Kube-Bench Job Master
wget https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job-master.yaml -n cis-benchmarks
kubectl apply -f job-master.yaml

# Waits 10 seconds before checking comopliance reports
sleep 10s

# Health Checks
kubectl logs -l "app=kube-bench"  -n cis-benchmarks
kubectl logs -l "job-name=kube-bench"  -n cis-benchmarks
kubectl logs -l "job-name=kube-bench-master"  -n cis-benchmarks

# Confirm Cluster Configuration
kubectl version
kubectl cluster-info
sudo docker run --rm -v 'pwd':/host aquasec/kube-bench:latest install
./kube-bench
