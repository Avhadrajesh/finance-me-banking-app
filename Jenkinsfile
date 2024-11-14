pipeline {
     agent any

	environment {	
		PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
		DOCKERHUB_CREDENTIALS=credentials('dockerlogin')
	}
	
	stages {
	    stage('SCM_Checkout') {
            steps {
                echo 'Perform SCM Checkout'
                git 'https://github.com/Avhadrajesh/finance-me-banking-app.git'
            }
	    }
	    
	stage('Application Build') {
            steps {
                echo 'Perform Application Build'
                sh 'mvn clean deploy'
            }
        }
    
    stage('Docker Build') {
            steps {
                echo 'Perform Docker Build'
		        sh "docker build -t rajesh4ever/banking-finance:${BUILD_NUMBER} ."
		        sh "docker tag rajesh4ever/banking-finance:${BUILD_NUMBER} rajesh4ever/banking-finance:latest"
		        sh 'docker image list'
            }
        }    
        
    stage('Login to Dockerhub') {
            steps {
                echo 'Login to DockerHub'				
		        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        
    stage('Publish the Image to Dockerhub') {
            steps {
                echo 'Publish to DockerHub'
		        sh "docker push rajesh4ever/banking-finance:latest"                
            }
        }
        
    stage('Deploying the application in Production server'){
            steps{
                echo 'deploying application'
                ansiblePlaybook(
                    playbook: 'ansible-playbook.yml',
                    inventory: '/opt/hosts',
                    credentialsId: 'ansible',
                    disableHostKeyChecking: true,
                    become: true,
                    vaultTmpPath: ''
                )
            }
        }    
	}
}
