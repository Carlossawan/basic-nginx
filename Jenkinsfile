pipeline {
    agent any

    environment {
        // Application repository containing the Dockerfile, index.html, picture.jpg, etc.
        APP_REPO = "https://github.com/Carlossawan/basic-nginx.git"
        // Manifests repository containing your Kubernetes YAML files
        MANIFESTS_REPO = "https://github.com/Carlossawan/deployment-manifests.git"
        
        // Docker image details:
        // Use your Docker registry domain and repository name.
        IMAGE_NAME = "http://dockerhub.idm.net.lb:8080/carlossawan/basic-nginx" 
        TAG = "${env.BUILD_NUMBER}"            // Using Jenkins build number as the image tag

        // Argo CD details
        ARGOCD_SERVER = "192.168.154.100"     // Replace with your Argo CD server address
        ARGOCD_PASSWORD = credentials('argocd-password-carlos')
        
        // Git configuration for manifest updates
        GIT_USER_EMAIL = "jenkins@example.com"
        GIT_USER_NAME  = "Jenkins"
    }

    stages {
        stage('Checkout App Repository') {
            steps {
                dir("app") {
                    // Clone the application repo containing your Dockerfile and static files.
                    git url: "${APP_REPO}", branch: "main"
                }
            }
        }

        stage('Checkout Manifests Repository') {
            steps {
                dir("manifests") {
                    // Clone the repository containing your Kubernetes manifests.
                    git url: "${MANIFESTS_REPO}", branch: "main"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile in the "app" directory.
                    dockerImage = docker.build("${IMAGE_NAME}:${TAG}", "./app")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                   docker.withRegistry('http://dockerhub.idm.net.lb:8080', null) {
                   dockerImage.push()
                    }             
                }
            }
        }

        stage('Update Deployment Manifest') {
            steps {
                script {
                    dir("manifests") {
                        // Configure Git user details.
                        sh """
                          git config user.email "${GIT_USER_EMAIL}"
                          git config user.name "${GIT_USER_NAME}"
                          # Replace the placeholder (IMAGE_TAG_PLACEHOLDER) in the manifest with the new image tag.
                          sed -i "s|IMAGE_TAG_PLACEHOLDER|${TAG}|g" nginx-dep.yaml
                          git add nginx-dep.yaml
                          git commit -m "Update image tag to ${TAG}" || echo "No changes to commit"
                          git push origin HEAD:main
                        """
                    }
                }
            }
        }

        
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please review the logs.'
        }
    }
}
