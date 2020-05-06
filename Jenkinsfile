pipeline {
  agent {
    docker {
      image '35.192.124.146:8123/boxfuse:1.0.0'
      args '-v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
  stages {
    stage('Copy source with configs') {
      steps {
        git 'https://github.com/itdani/boxfuse3.git'
      }
    }
    stage('Build war and upload war file in registry') {
      steps {
        sh 'mvn package'
        nexusArtifactUploader artifacts: [[artifactId: 'hello-1.0',
        classifier: 'debug', file: '/var/lib/jenkins/workspace/boxfuse/target/hello-1.0.war', type: 'war']],
        credentialsId: 'pas-nexus', groupId: 'sc', nexusUrl: '35.192.124.146:8081', nexusVersion: 'nexus3',
        protocol: 'http', repository: 'maven-releases', version: '1.0.1'
      }
    }
    stage('Build dockerfile and push') {
      steps {
        git 'https://github.com/itdani/Pipeline_for_boxfuse_method_2'  
        sh 'docker build --tag=prodimage:1.0.2 -f ./dockerfile_for_prod .'
        sh 'docker tag prodimage:1.0.2 35.192.124.146:8123/prodimage:1.0.2'
        withCredentials([usernamePassword(credentialsId: 'pas-nexus', passwordVariable: 'P', usernameVariable: 'A')]){
        sh 'docker login -u $A -p $P 35.192.124.146:8123'
        sh 'docker push 35.192.124.146:8123/prodimage:1.0.2'}
      }
    }
    stage('Deploy') {
      steps {
        sshagent(['ssh-key-jenkins']){
        sh 'ssh -o StrictHostKeyChecking=no -l root 18.196.102.1 docker run -d -p 8080:8080 35.192.124.146:8123/prodimage:1.0.2 && exit'}
      }
    }
  }
}
