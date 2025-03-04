pipeline{

 agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            //     image 'ubuntu'
            //     command 'sleep'
            //     args 'infinity'
            // }
            yaml '''
apiVersion: v1
kind: Pod
spec:
   containers:
   - name: shell
     image: chikitor/jenkins-nodo-nodejs-bootcamp:1.0
     volumeMounts:
      - mountPath: /var/run/docker.sock
        name: docker-socket-volume
     securityContext:
        privileged: true
   volumes:
   - name: docker-socket-volume
     hostPath:
       path: /var/run/docker.sock
       type: Socket
     command:
     - sleep
     args:
     - infinity
         '''
            // Can also wrap individual steps:
            // container('shell') {
            //     sh 'hostname'
            // }
            defaultContainer 'shell'
        }
    }

  environment {
    registryCredential='DockerId'
    registryFrontend = 'chikitor/frontend-demo'
  }

  stages {
    stage('Build') {
      steps {
        sh 'npm install' 
        sh 'npm run build &'
        sleep 25
      }
    }

    stage('Push Image to Docker Hub') {
      steps {
        script {
          dockerImage = docker.build registryFrontend + ":$BUILD_NUMBER"
          docker.withRegistry( '', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }

    stage('Push Image latest to Docker Hub') {
      steps {
        script {
          dockerImage = docker.build registryFrontend + ":latest"
          docker.withRegistry( '', registryCredential) {
            dockerImage.push()
          }
        }
      }
    }

    stage('Deploy to K8s') {

      steps{
        script {
          if(fileExists("configuracion")){
            sh 'rm -r configuracion'
          }
        }
        sh 'git clone https://github.com/Ferdevcenter/kubernetes-helm-docker-config.git configuracion --branch test-implementation'
        sh 'kubectl apply -f configuracion/kubernetes-deployment/angular-14-app/manifest.yml -n default --kubeconfig=configuracion/kubernetes-config/config'
      }

    }
  }

  post {
    always {
      sh 'docker logout'
    }
  }
}