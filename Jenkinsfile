pipeline {
    agent any

    stages {
        stage("code") {
            steps {
                git branch: "master", url: "https://github.com/sarthakjaruhar/docker-react-app.git"
            }
        }
        stage("Build") {
            steps {
                sh "docker build -t react-app ."
            }
        }
        stage("run") {
            steps {
                sh "docker run -d --name react-app -p 8000:8080 react-app"
            }
        }
        stage("deploy to dockerhub") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "dockerhubcreds",
                    passwordVariable: "dockerhubpass",
                    usernameVariable: "dockerhubuser"
                )]) {
                    sh "docker login -u ${dockerhubuser} -p ${dockerhubpass}"
                    sh "docker image tag react-app ${dockerhubuser}/react-app:latest"
                    sh "docker push ${dockerhubuser}/react-app:latest"
                }
            }
        }
    }
}
