resource "aws_eks_cluster" "eks" {
  name     = var.clusterName
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [var.subneta, var.subnetb]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${aws_eks_cluster.eks.name}-${var.clusterName}"
  node_role_arn   = aws_iam_role.eks.arn
  # subnet_ids      = aws_subnet.eks[*].id
  subnet_ids      = [var.subneta,var.subnetb]
  instance_types  = [var.instance_types]

  scaling_config {
    desired_size = var.desiredSize
    max_size     = var.maxSize
    min_size     = var.desiredSize
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}
