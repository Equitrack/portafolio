output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "minikube_private_ip" {
  value = aws_instance.minikube.private_ip
}

output "kubespray_private_ip" {
  value = aws_instance.kubespray.private_ip
}
