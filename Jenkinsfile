pipeline {
    agent any
    environment{
        IMAGE_REPO = "mukeshdevops/galewebserver"
    }
    stages {
        stage('Provision EC2 Instance') {
            steps {
                script {
                    dir('terraform') {
                        echo "Creating EC2 instance"
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        env.AWS_EC2_PUBLIC_IP = sh(
                            script: "terraform output aws_ec2_public_ip",
                            returnStdout: true
                        ).trim()
                        echo "Public IP is -- ${AWS_EC2_PUBLIC_IP}"
                        sh "export AWS_EC2_PUBLIC_IP=${AWS_EC2_PUBLIC_IP}"
                    }
                }
            }
        }
        
        stage("Static Code Analysis"){
            steps{
                echo "Perform static code analysis"
            }
        }

        stage("Build Application"){
            steps{
                echo "Building Application..."
            }
        }

        stage("Testing"){
            steps{
                echo "Testing..."
            }
        }

        stage("Code Quality"){
            steps{
                echo "Perform Code quality using cobertura"
            }

        }

        stage("Packaging"){
            steps{
                echo "Packaging the application..."
            }

        }
        stage('Build and push docker image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'DockerHub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${IMAGE_REPO} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${IMAGE_REPO}"
                    }

                }
            }
        }
        stage("Copy files to ansible server") {
            steps {
                echo "Copy to Ansible server if ansible controller is running in different machine"
                /*
                script {
                    echo "copying all neccessary files to ansible control node"
                    sshagent(['ansible-server-key']) {
                        sh "scp -o StrictHostKeyChecking=no ansible/* ansible@${ANSIBLE_SERVER}:/ansible"

                        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                            sh 'scp $keyfile ansible@$ANSIBLE_SERVER:/ansible/ssh-key.pem'
                        }
                    }
                }
                */
            }
        }

        stage('Deploy to EC2 using ansible') {
            steps {
                script {
                    echo 'Deploying onto EC2 instance...'
                    dir('ansible') {
                        sh "ansible-playbook -i inventory_aws_ec2.yaml nginx_configuration.yaml"
                    }
                }
            }
        }


    }
    post{
        failure {
           /* mail to: 'devopsTeamDL@gale.com',
                 subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
                 body: "Something is wrong with ${env.BUILD_URL}" */
            echo "Build Failed..."
        }
        success {
            /* mail to: 'devopsTeamDL@gale.com',
                 subject: "Pipeline Succeded: ${currentBuild.fullDisplayName}",
                 body: "Build is Successfull: ${env.BUILD_URL}" */
            echo "Build Successfull"
        }

    }
}