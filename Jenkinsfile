pipeline {
    agent any

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-east-2', description: 'AWS Region for deployment')
        booleanParam(name: 'APPROVE', defaultValue: false, description: 'Approve Terraform changes')
        booleanParam(name: 'PLAN', defaultValue: false, description: 'Run Terraform plan')
        booleanParam(name: 'DESTROY', defaultValue: false, description: 'Run Terraform destroy')
    }

    stages {
        stage('Terraform Apply/Plan/Destroy') {
            steps {
                script {
                    // Use AWS credentials from Jenkins Credentials
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_cred', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        // Change to your Terraform directory
                        dir('1-pet-infra/terraform') {
                            sh 'terraform init -input=false'

                            if (params.PLAN) {
                                sh "terraform plan -var 'region=${params.AWS_REGION}' -input=false"
                            } else if (params.DESTROY) {
                                input "Do you want to destroy the infrastructure? (Requires approval)"
                                sh "terraform destroy -auto-approve -var 'region=${params.AWS_REGION}'"
                            } else if (params.APPROVE) {
                                input "Do you want to apply Terraform changes? (Requires approval)"
                                sh "terraform apply -auto-approve -var 'region=${params.AWS_REGION}'"
                            } else {
                                echo "No action specified. Set 'PLAN', 'DESTROY', or 'APPROVE' parameter."
                            }
                        }
                    }
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                script {
                    // Change to your Ansible directory
                    dir('1-pet-infra/ansible') {
                        sh 'ansible-playbook --vault-id .password site.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
