get-started-k8s
----

Get Started with MongoDB and Kubernetes with a new Get-Started project!

starter Get-Started for MongoDB k8s.

Goal - simple way to run local dbs with k8s using CloudManager.

Usage
---

1. Setup and install `mongocli` and `kubectl` - right now you need to BYOK8s, bring your own k8s cluster. Suggest `eksctl create-cluster`.

2. Create a Cloud Manager API Key with at least Project Creator and use this in `mongocli config`.

3. Run the get-started.sh and pass your APIKEY from mongocli's configuration:

```bash
./get-started.sh $(./export-mongocli-config.py default spaces)
```

__TODO__ Need more testing!
