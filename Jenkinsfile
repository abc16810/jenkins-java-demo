//scripts pipeline
podTemplate(containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent:jdk11', args: '${computer.jnlpmac} ${computer.name}'),

  ]) {
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        stage('Run shell') {
            sh 'echo hello world'
            sh "pwd && ls -l"
        }
    }
}