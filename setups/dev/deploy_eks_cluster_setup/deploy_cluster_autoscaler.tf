resource helm_release ins-cluster-autoscaler {
  depends_on = [ module.eks ]
  name             = "cluster-autoscaler"
  repository       = "https://kubernetes-charts.storage.googleapis.com/"
  chart            = "cluster-autoscaler"
  namespace        = "kube-system"
  set {
    name  = "awsRegion"
    value = "${var.region}"
  }
  set {
    name  = "rbac.create"
    value = "true"
  } 
  set {
    name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cluster-autoscaler"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = "${local.cluster_name}"
  }
  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

}

