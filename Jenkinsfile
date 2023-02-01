//scripts pipeline
podTemplate {
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        stage('Run shell') {
            sh 'echo hello world'
            sh "pwd && ls -l"
        }
    }
}