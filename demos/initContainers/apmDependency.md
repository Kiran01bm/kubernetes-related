## AppAgent - Java

### Overview
One of the Best Practices approach to deploy App Dyanmics App Agents to OpenShift Container Platform is to use the Init Container approach. Init Container to place the AppD jar into a shared ephemeral storage which can be picked up by the Application.

Benefits of this approach is:
1. We separate the release cadence for Application and the AppD Binaries
2. Application image only gets built when there is a change to the Business Logic
3. Faster Application Image Pulls


### Init Container Image
The Init container is being built using the OpenJDK base image for OpenShift. Docker file below. 

```
FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

RUN mkdir -p /tmp/sharedFiles/AppServerAgent

ADD AppServerAgent.zip /tmp/sharedFiles/
RUN unzip /tmp/sharedFiles/AppServerAgent.zip -d /tmp/sharedFiles/AppServerAgent
RUN rm /tmp/sharedFiles/AppServerAgent.zip

CMD [“tail”, “-f”, “/dev/null”]
```

### Changes to Java Service Boot Script
Feed in all the configuration parameters required for AppAgent via OpenShift ConfigMap and Secrets and consume them in the application boot-script as show below.  The AppD app agent configuration parameters are fed in via APPDMON_OPTS environment variable.

Application BootScript changes 

```
export APPDMON_OPTS=" -javaagent:/mountPath/AppServerAgent/javaagent.jar -Dappdynamics.controller.hostName=${APPD_CONTROLLER_HOSTNAME} -Dappdynamics.controller.port=${APPD_CONTROLLER_PORT} -Dappdynamics.agent.accountName=${APPD_ACCOUNT_NAME} -Dappdynamics.agent.applicationName=${APPD_APPLICATION_NAME} -Dappdynamics.agent.tierName=${APPD_TIER_NAME} -Dappdynamics.agent.accountAccessKey=${ACCOUNT_ACCESS_KEY} -Dappdynamics.http.proxyHost=${APPD_PROXY_HOST} -Dappdynamics.http.proxyPort=${APPD_PROXY_PORT} -Dappdynamics.controller.ssl.enabled=${APPDYNAMICS_CONTROLLER_SSL_ENABLED} -Dappdynamics.agent.reuse.nodeName.prefix=ocp-${XXXX_SERVICE_NAME} -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.uniqueHostId=$(sed -rn '1s#.*/##; 1s/docker-(.{12}).*/\1/p' /proc/self/cgroup)"

java $JAVA_OPTS $APP_OPTS $APPDMON_OPTS -Djava.security.egd=file:/dev/./urandom -jar /XXXX-java-service/XXXX-service.jar
Sample Java Service Boot Script'
Sample Java Service Boot Script  
#!/bin/sh
#set -x

if  [ "$ENVIRONMENT" = "dev" ] || [ "$ENVIRONMENT" = "sit" ]; then
   export APPDMON_OPTS=""
elif  [ "$ENVIRONMENT" = "ppt" ] || [ "$ENVIRONMENT" = "prod" ]; then
   export APPDMON_OPTS=" -javaagent:/mountPath/AppServerAgent/javaagent.jar -Dappdynamics.controller.hostName=${APPD_CONTROLLER_HOSTNAME} -Dappdynamics.controller.port=${APPD_CONTROLLER_PORT} -Dappdynamics.agent.accountName=${APPD_ACCOUNT_NAME} -Dappdynamics.agent.applicationName=${APPD_APPLICATION_NAME} -Dappdynamics.agent.tierName=${APPD_TIER_NAME} -Dappdynamics.agent.accountAccessKey=${ACCOUNT_ACCESS_KEY} -Dappdynamics.http.proxyHost=${APPD_PROXY_HOST} -Dappdynamics.http.proxyPort=${APPD_PROXY_PORT} -Dappdynamics.controller.ssl.enabled=${APPDYNAMICS_CONTROLLER_SSL_ENABLED} -Dappdynamics.agent.reuse.nodeName.prefix=ocp-${XXXX_SERVICE_NAME} -Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.uniqueHostId=$(sed -rn '1s#.*/##; 1s/docker-(.{12}).*/\1/p' /proc/self/cgroup)"
fi


java $JAVA_OPTS $APP_OPTS $APPDMON_OPTS -Djava.security.egd=file:/dev/./urandom -jar /XXXX-java-service/XXXX-service.jar
```


### AppD ConfigurationMap
Create one configmap per AppD config set. Content below. This configmap will be consumed by the Java Boot script via environment variables in the Java Service Deployment template.
AppD Configmap 
apiVersion: v1
data:
  appd.accountName: XXXX
  appd.applicationName: XXXX
  appd.controllerHostName: XXXX.saas.appdynamics.com
  appd.controllerPort: '443'
  appd.controllerSSL: 'true'
  appd.proxyHost: someproxy.example.com
  appd.proxyPort: '4567'
  appd.tierName: XXXX
kind: ConfigMap
metadata:
  name: appd-configmap
  namespace: XXXX

### AppD Secret to Consume Access Key
This secret will be consumed by the Java Boot script via environment variables in the Java Service Deployment template.

AppD AccessKey - OpenShift Secret 
```
apiVersion: v1
data:
  appd.accountAccessKey: <<REDACTED>>
kind: Secret
metadata:
  creationTimestamp: null
  name: appd-secret
type: Opaque
```

The above secret is created using the below command:

```
oc create secret generic appd-secret --from-literal=appd.accountAccessKey=<<REDACTED_ACCESS_KEY>>
```

### Java Service Deployment Template
This is an example template of a Java micro-service from Intellect with AppD specific environment variables. Example Spring Boot Application with Netflix Toolset.

```
apiVersion: v1
kind: Template
labels:
  template: java-microservice-template
message: |-
  The following service(s) have been created in your project: ${PROJECT_NAME}.

         Service: ${SERVICE_NAME} version ${SERVICE_VERSION}

  For more information about using this template, including OpenShift considerations, see SOME_LINK_TO_IGTB_PUBLIC_DOCS.

metadata:
  name: app1-deployment-template
  annotations:
    description: |-
      Deployment descriptors for app1, no persistent storage.

      NOTE: Some limitations.

objects:
- apiVersion: v1
  kind: Service
  metadata:
    labels:
      project: ${PROJECT_NAME}
    name: ${SERVICE_NAME}-service
  spec:
    ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 50000
    selector:
      name: ${SERVICE_NAME}-deployment
    type: ${SERVICE_TYPE}

- apiVersion: v1
  kind: DeploymentConfig
  metadata:
    labels:
      project: ${PROJECT_NAME}
    name: ${SERVICE_NAME}
  spec:
    replicas: 1
    template:
      metadata:
        labels:
          name: ${SERVICE_NAME}-deployment
      spec:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: name
                  operator: In
                  values:
                  - ${SERVICE_NAME}-deployment
              topologyKey: "kubernetes.io/hostname"
        initContainers:
        - image: XXXX
          name: appd-init
          imagePullPolicy: IfNotPresent
          command: ["cp",  "-r",  "/tmp/sharedFiles/AppServerAgent",  "/mountPath/AppServerAgent"]
          volumeMounts:
          - name: shared-files
            mountPath: /mountPath
        volumes:
        - emptyDir: {}
          name: shared-files
        containers:
        - env:
          - name: JAVA_OPTS
            valueFrom:
              configMapKeyRef:
                key: jvm-options
                name: ${SERVICE_NAME}-config
          - name: logging.level.
            valueFrom:
              configMapKeyRef:
                key: logging-level
                name: ${SERVICE_NAME}-config
          - name: security.basic.enabled
            valueFrom:
              configMapKeyRef:
                key: security-basic-enabled
                name: ${SERVICE_NAME}-config
          - name: spring.application.name
            valueFrom:
              configMapKeyRef:
                key: spring-application-name
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.services.registrationMethod
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-services-registrationMethod
                name: ${SERVICE_NAME}-config

          # Config repository
          - name: spring.cloud.config.name
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-name
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.config.discovery.enabled
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-discovery-enabled
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.config.fail-fast
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-fail-fast
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.config.discovery.serviceId
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-discovery-serviceId
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.config.profile
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-profile
                name: ${SERVICE_NAME}-config
          - name: spring.cloud.config.label
            valueFrom:
              configMapKeyRef:
                key: spring-cloud-config-label
                name: ${SERVICE_NAME}-config

          # Registry settings
          - name: eureka.client.enabled
            valueFrom:
              configMapKeyRef:
                key: eureka-client-enabled
                name: ${SERVICE_NAME}-config
          - name: eureka.instance.preferIpAddress
            valueFrom:
              configMapKeyRef:
                key: eureka-instance-preferIpAddress
                name: ${SERVICE_NAME}-config
          - name: eureka.client.registerWithEureka
            valueFrom:
              configMapKeyRef:
                key: eureka-client-registerWithEureka
                name: ${SERVICE_NAME}-config

          # Registry Service Bindings
          - name: REGISTRY_HOSTNAME
            valueFrom:
              configMapKeyRef:
                key: hostname
                name: registry-service-bindings-config
          - name: REGISTRY_PORT
            valueFrom:
              configMapKeyRef:
                key: port
                name: registry-service-bindings-config
          - name: REGISTRY_PROTOCOL
            valueFrom:
              configMapKeyRef:
                key: protocol
                name: registry-service-bindings-config
          - name: REGISTRY_USERNAME
            valueFrom:
              secretKeyRef:
                key: username
                name: registry-service-bindings-secrets
          - name: REGISTRY_PASSWORD
            valueFrom:
              secretKeyRef:
                key: password
                name: registry-service-bindings-secrets

    # AppD Configuration Information
          - name: ENVIRONMENT
              value: ppte

          - name: XXXX_SERVICE_NAME
              valueFrom:
                configMapKeyRef:
                  key: spring-application-name
                  name: digital-limits-config

          - name: APPDYNAMICS_CONTROLLER_HOST_NAME
            valueFrom:
              configMapKeyRef:
                key: appd.controllerHostName
                name: appd-configmap

          - name: APPDYNAMICS_CONTROLLER_PORT
            valueFrom:
              configMapKeyRef:
                key: appd.controllerPort
                name: appd-configmap

          - name: APPDYNAMICS_CONTROLLER_SSL_ENABLED
            valueFrom:
              configMapKeyRef:
                key: appd.controllerSSL
                name: appd-configmap

          - name: APPDYNAMICS_AGENT_ACCOUNT_NAME
            valueFrom:
              configMapKeyRef:
                key: appd.accountName
                name: appd-configmap

          - name: APPDYNAMICS_AGENT_APPLICATION_NAME
            valueFrom:
              configMapKeyRef:
                key: appd.applicationName
                name: appd-configmap

          - name: APPDYNAMICS_AGENT_TIER_NAME
            valueFrom:
              configMapKeyRef:
                key: appd.tierName
                name: appd-configmap

          - name: ACCOUNT_ACCESS_KEY
            valueFrom:
              secretKeyRef:
                key: appd.accountAccessKey
                name: appd-secret

          - name: APPD_PROXY_HOST
            valueFrom:
              configMapKeyRef:
                key: appd.proxyHost
                name: appd-configmap

          - name: APPD_PROXY_PORT
            valueFrom:
              configMapKeyRef:
                key: appd.proxyPort
                name: appd-configmap
          image: "${DOCKER_REGISTRY}/${SERVICE_NAME}:${SERVICE_VERSION}"
          name: ${SERVICE_NAME}-java-service
          volumeMounts:
          - name: shared-files
            mountPath: /mountPath
          ports:
            - containerPort: 50000
          imagePullPolicy: Always
          resources:
            requests:
              cpu: '400m'
            memory: '400Mi'
            limits:
              cpu: '600m'
              memory: '800Mi'
          readinessProbe:
            initialDelaySeconds: 30
            tcpSocket:
              port: 51001
            initialDelaySeconds: 120
            timeoutSeconds: 5
          livenessProbe:
            initialDelaySeconds: 30
            tcpSocket:
              port: 51001
            initialDelaySeconds: 120
            timeoutSeconds: 5
            failureThreshold: 10

parameters:
- description: Openshift project to be used.
  displayName: openshift project
  name: PROJECT_NAME
  required: true
  value: "XXXX"
- description: Docker REGISTRY URI (igtb).
  displayName: Docker REGISTRY URI
  name: DOCKER_REGISTRY
  required: true
  value: "XXXX"
- description: Name of service to be used
  displayName: Name of service to be used
  name: SERVICE_NAME
  required: false
  value: "XXXX"
- description: Version of SERVICE image to be used (XXXX.YYYY.ZZZZ).
  displayName: Version of SERVICE Image
  name: SERVICE_VERSION
  required: true
  value: XXXX"
- description: Openshift Service Type (clusterIP , NodePort).
  displayName: Openshift Service Type
  name: SERVICE_TYPE
  required: true
  value: "XXXX"
```
