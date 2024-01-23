pipeline {
    agent any

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-east-2', description: 'AWS Region for deployment')
        booleanParam(name: 'CREATE_RESOURCES', defaultValue: false, description: 'Create AWS resources')
        booleanParam(name: 'DESTROY_RESOURCES', defaultValue: false, description: 'Destroy AWS resources')
        booleanParam(name: 'ASK_FOR_CONFIRMATION', defaultValue: true, description: 'Ask for confirmation before applying or destroying resources')
        booleanParam(name: 'ONLY_PLAN', defaultValue: false, description: 'Only run Terraform plan')
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

                            if (params.ONLY_PLAN) {
                                // Display Terraform plan
                                sh "terraform plan -var 'region=${params.AWS_REGION}' -input=false"
                            } else {
                                def terraformCommand = "terraform ${params.DESTROY_RESOURCES ? 'destroy -auto-approve' : 'apply -auto-approve'} -var 'region=${params.AWS_REGION}'"

                                if (params.ASK_FOR_CONFIRMATION && (params.CREATE_RESOURCES || params.DESTROY_RESOURCES)) {
                                    // Display Terraform plan
                                    sh "terraform plan -var 'region=${params.AWS_REGION}' -input=false"

                                    // Prompt for explicit approval
                                    input "Do you want to apply/destroy Terraform changes? (Requires approval)"
                                }

                                // Execute Terraform command
                                sh terraformCommand
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
