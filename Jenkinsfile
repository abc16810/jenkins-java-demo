//scripts pipeline
podTemplate(yaml: readTrusted('pod.yaml'), containers: [
    containerTemplate(name: 'maven', image: 'myregistry.io:8088/library/maven:3.8.1-jdk-8', command: 'sleep', args: '99d')],
    volumes: [hostPathVolume(hostPath: '/home/jenkins/m2', mountPath: '/root/.m2')]
) {
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        stage('Run shell') {
            checkout scm
            sh 'echo hello world'
            sh "pwd && ls -l"
        }
        stage('Get a Maven project') {
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn -v && ls -l && pwd'
                }
            }
        }
    }
}