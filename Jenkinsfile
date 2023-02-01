//scripts pipeline
podTemplate(yaml: readTrusted('pod.yaml'), containers: [
    containerTemplate(name: 'maven', image: 'myregistry.io:8088/library/maven:3.8.1-jdk-8', command: 'sleep', args: '99d')],
    volumes: [hostPathVolume(hostPath: '/home/jenkins/m2', mountPath: '/root/.m2')],
    workspaceVolume: hostPathWorkspaceVolume(hostPath: "/home/jenkins/agent", readOnly: false) //持久化工作目录
) {
    properties([
        parameters([
            gitParameter(branch: '',
                        branchFilter: 'origin/(.*)',
                        defaultValue: 'master',
                        description: '',
                        name: 'Name',
                        quickFilterEnabled: false,
                        selectedValue: 'NONE',
                        sortMode: 'NONE',
                        tagFilter: '*',
                        type: 'PT_BRANCH')
        ])
    ])
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        stage('Run shell') {
            sh 'echo hello world'
            println "开始对分支 ${params.Name} 进行构建"
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