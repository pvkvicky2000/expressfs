# expressfs is a Simple Static file server over http
You can use it to upload and download files

# Running expressfs locally 
1. You need to have nodejs installed
2. Clone repository
3. Run: 
    ``node app.js``


# Deploy in OpenShift 

Import below YAML definition. It will create a Deployment, Service and Route in `default` project. Route will be automatically generated. Change the values as per your need. Involved resources can be separately created as well. 
```yaml
---
kind: Deployment
apiVersion: apps/v1
metadata:  
  name: expressfs     
  namespace: default  
spec:
  replicas: 1
  selector:
    matchLabels:
      app: expressfs
  template:
    metadata:     
      labels:
        app: expressfs
        deploymentconfig: expressfs
    spec:
      containers:
        - name: expressfs
          image: ghcr.io/pvkvicky2000/expressfs:1.0
          ports:
            - containerPort: 8080
          terminationMessagePath: /dev/termination-log
          terminationMessagePolicy: File
          imagePullPolicy: Always
      restartPolicy: Always
      terminationGracePeriodSeconds: 30
      dnsPolicy: ClusterFirst
      securityContext: {}
      schedulerName: default-scheduler
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
---
apiVersion: v1
kind: Service
metadata:
  name: expressfs
  namespace: default
spec:
  selector:
    app: expressfs
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
---
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: expressfs
  namespace: default
spec:
  path: /
  to:
    kind: Service
    name: expressfs
  port:
    targetPort: 8080
```
