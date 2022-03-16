Pre-requiste:
1.Create keypair using ssh-keygen
	"ssh-keygen"
	Copy the public key to terraform directory
2.Copy the private key to ansible controller and update the ansible.cfg inside ansible directory accordingly
3.In my case I used AWSLinux2 AMI

Step1: Execute Terraform main.tf to provision the EC2 instance on AWS Cloud
	   Update the my_public_ip in .tfvars file before running the below command
	   "cd terraform"
	   "terraform init"
	   "terraform apply -auto-approve"
	   
Step2: Create the docker image and push it to dockerhub
	   "docker build -t <image name>"
	   "echo <password> | docker login -u <user> --password-stdin"
	   "docker push <image name>"
	   
Step3: Run Asible playbooks for configuring and deploying nginx container onto EC2 instance
	   Run the below command inside ansible directory
	   "cd ansible"
	   "ansible-playbook -i inventory_aws_ec2.yaml nginx_configuration.yaml"

Step4: Run HealthCheck python script which runs every 10 seconds to monitor the 
	   "cd terraform"
	   "export AWS_EC2_PUBLIC_IP=`terraform output aws_ec2_public_ip`"
	   "python3 healthcheck.py"

We can also use jenkinsfile to automate this workflow, I have also added a jenkinsfile with basic stages

Once we are done we can destroy the resources created using terraform using the below command
"terraform destroy -auto-approve"
