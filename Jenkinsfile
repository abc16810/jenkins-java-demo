//scripts pipeline
podTemplate(containers: [
    containerTemplate(name: 'jnlp', image: 'jenkins/inbound-agent:jdk11', args: '${computer.jnlpmac} ${computer.name}')],
    nodeSelector: 'kubernetes.io/hostname: "utility1"',
    tolerations: [effect: "NoSchedule", operator: "Exists"]

    ) {
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        stage('Run shell') {
            sh 'echo hello world'
            sh "pwd && ls -l"
        }
    }
}