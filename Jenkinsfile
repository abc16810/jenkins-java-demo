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
                        type: 'PT_BRANCH',
                        useRepository: '.*assessment-web.git')
        ])
    ])
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        withEnv([
            'REPO_HTTP=http://10.4.56.155/lumanman/performance-task-assessment-web.git',
            'GIT_AUTH_ID=ea2f709f-9cac-4978-aeb2-9fc37e8e9667',
            'HARBOR_ADDRESS=myregistry.io:8088',
            'HARBOR_AUTH=credentials("harborAuth")',
            'IMAGE_NAME=my-test-java'
            ]){
            stage('Run shell') {
                sh 'echo hello world'
                println "开始对分支 ${params.Name} 进行构建"
                git branch: "${params.Name}", credentialsId: "${GIT_AUTH_ID}", url: "${REPO_HTTP}"
                git 'http://10.4.56.155/maojinglei/finance-process-service.git'
                sh "pwd && ls -l"
            }
            stage('Get a Maven project') {
                container('maven') {
                    stage('Build a Maven project') {
                        sh 'mvn -v && ls -l && pwd'
                    }
                }
            }
            // Archive the built artifacts
            //archive (includes: 'pkg/*.gem')
        }   
    }
}