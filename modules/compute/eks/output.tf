output "eks_cluster_name"    {value = aws_eks_cluster.main.*.id}
output "eks_node_group_name" {value = aws_eks_node_group.main.*.id}
#output "eks_asg_name"        {value = aws_eks_node_group.main.resources[0]["autoscaling_groups"][0]["name"]}