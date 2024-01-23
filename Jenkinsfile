pipeline {
    agent any

    parameters {
        booleanParam(name: 'CREATE_RESOURCES', defaultValue: false, description: 'Create Terraform resources')
        booleanParam(name: 'DESTROY_RESOURCES', defaultValue: false, description: 'Destroy Terraform resources')
        booleanParam(name: 'ASK_FOR_CONFIRMATION', defaultValue: true, description: 'Ask for approval before applying or destroying')
        booleanParam(name: 'ONLY_PLAN', defaultValue: false, description: 'Run Terraform plan only')
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
                                sh 'terraform plan -input=false'
                            } else {
                                // Display Terraform plan
                                sh 'terraform plan -input=false'
                                
                                // Prompt for approval only if PLAN is true and ASK_FOR_CONFIRMATION is selected
                                if (params.ASK_FOR_CONFIRMATION && (params.CREATE_RESOURCES || params.DESTROY_RESOURCES)) {
                                    if (params.CREATE_RESOURCES) {
                                        input "Do you want to apply Terraform changes? (Requires approval)"
                                        sh 'terraform apply -auto-approve'
                                    } else if (params.DESTROY_RESOURCES) {
                                        input "Do you want to destroy the infrastructure? (Requires approval)"
                                        sh 'terraform destroy -auto-approve'
                                    }
                                } else if (params.CREATE_RESOURCES) {
                                    // Apply Terraform changes without approval
                                    sh 'terraform apply -auto-approve'
                                } else if (params.DESTROY_RESOURCES) {
                                    // Destroy infrastructure without approval
                                    sh 'terraform destroy -auto-approve'
                                }
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
                        // Only run Ansible if create_resources or destroy_resources are selected
                        if (params.CREATE_RESOURCES || params.DESTROY_RESOURCES) {
                            sh 'ansible-playbook --vault-id .password site.yml'
                        } else {
                            echo 'Skipping Ansible configuration as no infra is provisioned.'
                        }
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
