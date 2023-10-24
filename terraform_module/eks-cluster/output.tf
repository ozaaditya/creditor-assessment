output "eks_cluster_id" {
  value = aws_eks_cluster.creditor-assessment-cluster.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.creditor-assessment-cluster.name
}
