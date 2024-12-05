#locals {
#  mkectl_config = <<-EOT
#
#apiVersion: mke.mirantis.com/v1alpha1
#kind: MkeConfig
#metadata:
#  creationTimestamp: null
#  name: mke 
#  namespace: mke
#spec:
#  hosts:
#    %{~for manager in module.managers}
#    - role: "controller+worker"
#      ssh:
#        address: ${manager.ip_address}
#        keyPath: ${var.ssh_private_key_file}
#        port: 22
#        user: ${var.vm_user}
#    %{~endfor~}
#    %{~for worker in module.workers}
#    - role: "worker"
#      ssh:
#        address: ${worker.ip_address}
#        keyPath: ${var.ssh_private_key_file}
#        port: 22
#        user: ${var.vm_user}
#    %{~endfor~}
#  addons:
#  - chart:
#      name: metallb
#      repo: https://metallb.github.io/metallb
#      values:
#        controller:
#          tolerations:
#          - effect: NoSchedule
#            key: node-role.kubernetes.io/master
#            operator: Exists
#        speaker:
#          frr:
#            enabled: false
#      version: 0.14.7
#    dryRun: false
#    enabled: false
#    kind: chart
#    name: metallb
#    namespace: metallb-system
#  apiServer:
#    externalAddress: ${var.external_address}
#    audit:
#      enabled: false
#      logPath: /var/log/mke4_audit.log
#      maxAge: 30
#      maxBackup: 10
#      maxSize: 10
#    encryptionProvider: /var/lib/k0s/encryption.cfg
#    eventRateLimit:
#      enabled: false
#    requestTimeout: 1m0s
#  authentication:
#    expiry:
#      refreshTokens: {}
#    ldap:
#      enabled: false
#    oidc:
#      enabled: false
#    saml:
#      enabled: false
#  backup:
#    enabled: true
#    scheduled_backup:
#      enabled: false
#    storage_provider:
#      external_options: {}
#      in_cluster_options:
#        admin_credentials_secret: minio-credentials
#        enable_ui: true
#      type: InCluster
#  cloudProvider:
#    enabled: false
#  controllerManager:
#    terminatedPodGCThreshold: 12500
#  devicePlugins:
#    nvidiaGPU:
#      enabled: false
#  dns:
#    lameduck: {}
#  etcd: {}
#  ingressController:
#    enableLoadBalancer: true
#    affinity:
#      nodeAffinity: {}
#    enabled: true
#    extraArgs:
#      defaultSslCertificate: mke/mke-ingress.tls
#      enableSslPassthrough: false
#      httpPort: 80
#      httpsPort: 443
#    nodePorts: {}
#    ports: {}
#    replicaCount: 2
#  kubelet:
#    eventRecordQPS: 50
#    managerKubeReserved:
#      cpu: 250m
#      ephemeral-storage: 4Gi
#      memory: 2Gi
#    maxPods: 110
#    podPidsLimit: -1
#    podsPerCore: 0
#    protectKernelDefaults: false
#    seccompDefault: false
#    workerKubeReserved:
#      cpu: 50m
#      ephemeral-storage: 500Mi
#      memory: 300Mi
#  license:
#    token: ""
#  monitoring:
#    enableCAdvisor: false
#    enableGrafana: true
#    enableOpscare: false
#  network:
#    cplb:
#      disabled: false
#      controlPlaneLoadBalancing:
#        enabled: true
#        keepalived:
#          vrrpInstances:
#            - virtualIPs: ["${var.external_address}/24"]
#              authPass: test
#    kubeProxy:
#      iptables:
#        minSyncPeriod: 0s
#        syncPeriod: 0s
#      ipvs:
#        minSyncPeriod: 0s
#        syncPeriod: 0s
#        tcpFinTimeout: 0s
#        tcpTimeout: 0s
#        udpTimeout: 0s
#      metricsBindAddress: 0.0.0.0:10249
#      mode: iptables
#    nllb:
#      disabled: true
#    nodePortRange: 32768-35535
#    providers:
#    - enabled: true
#      extraConfig:
#        CALICO_DISABLE_FILE_LOGGING: "true"
#        CALICO_STARTUP_LOGLEVEL: DEBUG
#        FELIX_LOGSEVERITYSCREEN: DEBUG
#        clusterCIDRIPv4: 192.168.0.0/16
#        deployWithOperator: "false"
#        enableWireguard: "false"
#        ipAutodetectionMethod: ""
#        mode: vxlan
#        overlay: Always
#        vxlanPort: "4789"
#        vxlanVNI: "10000"
#      provider: calico
#    - enabled: false
#      extraConfig:
#        deployWithOperator: "false"
#      provider: custom
#    serviceCIDR: 10.96.0.0/16
#  policyController:
#    opaGatekeeper:
#      enabled: false
#  scheduler: {}
#  tracking:
#    enabled: true
#  version: v4.0.0
#EOT
#}
#
#output "mkectl_config" {
#  value = local.mkectl_config
#  #  value = yamlencode(local.ansible_inventory)
#}
