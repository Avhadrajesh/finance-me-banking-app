pipeline {
    agent {
        node {
            label 'maven'  // Runs on a node with the 'maven' label
        }
    }

    stages {
        // Stage 1: Print "Hello World"
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }

        // Stage 2: Print "Goodbye World"
        stage('Goodbye') {
            steps {
                echo 'Goodbye World'
            }
        }

        // Stage 3: Print completion message
        stage('Completion') {
            steps {
                echo 'Pipeline execution is complete.'
            }
        }
    }
}
