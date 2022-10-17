# CIS-Compliant-Kubernetes

The Center for Information Security (CIS) provided an objective, consensus-driven security guideline for the Kubernetes Server Software. <br/>
https://www.cisecurity.org/benchmark/kubernetes

## Creating a Pre-Packaged Lab Environment

1. SSH into one of your VM's and run this on the dedicated VM (which will become the master node)

```
curl https://raw.githubusercontent.com/n1g3ld0ugla5/CIS-Compliant-Kubernetes/main/master.sh | bash
```

2. SSH into at least one other VM's (these will be known as worker nodes) <br/>
For the purpose of testing Kubernetes compliance on worker nodes, we need to add one.

```
curl https://raw.githubusercontent.com/n1g3ld0ugla5/CIS-Compliant-Kubernetes/main/worker.sh | bash
```

After this step, check that all pods are created but not running <br/>
This is because we have yet to install our networking layer:

```
kubectl get pods -A
```

If you joined the nodes from the above steps, you should be able to confirm their status:

```
kubectl get nodes -o wide
```

## Creating a zero-trust network architecture

Project Calico is a Pure Layer 3 Approach to Virtual Networking for Highly Scalable Data Centers. <br/>
https://github.com/projectcalico <br/>
<br/>

This also packages the admission controller which is required to prevent workloads from being created <br/>
https://github.com/open-policy-agent/gatekeeper


```
curl https://raw.githubusercontent.com/n1g3ld0ugla5/CIS-Compliant-Kubernetes/main/tools.sh | bash
```


## Benchmarking Kubernetes with Kube-Bench

kube-bench is a tool that checks whether Kubernetes is deployed securely by running the checks documented in the CIS Kubernetes Benchmark. <br/>
https://github.com/aquasecurity/kube-bench
