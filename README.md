# CIS-Compliant-Kubernetes

The Center for Information Security (CIS) provided an objective, consensus-driven security guideline for the Kubernetes Server Software. <br/>
https://www.cisecurity.org/benchmark/kubernetes

## Creating a Pre-Packaged Lab Environment

SSH into one of your VM's and run this on the dedicated VM (which will become the master node)

```
curl https://raw.githubusercontent.com/n1g3ld0ugla5/CIS-Compliant-Kubernetes/main/master.sh | bash
```

SSH into at least one other VM's (these will be known as worker nodes)

```
curl https://raw.githubusercontent.com/n1g3ld0ugla5/CIS-Compliant-Kubernetes/main/worker.sh | bash
```

## Creating a zero-trust network architecture


