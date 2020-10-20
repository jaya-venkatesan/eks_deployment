resource null_resource windows-node-support {
  depends_on = [ module.eks,helm_release.ins-cluster-autoscaler ]
  provisioner local-exec {
    command = <<EOT
      eksctl utils install-vpc-controllers --cluster=${local.cluster_name} --approve
   EOT  
  } 
}
