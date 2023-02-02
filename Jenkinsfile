//scripts pipeline
podTemplate(yaml: readTrusted('pod.yaml'), containers: [
    containerTemplate(name: 'maven', image: 'myregistry.io:8088/library/maven:3.8.1-jdk-8', command: 'sleep', args: '99d')],
    volumes: [hostPathVolume(hostPath: '/home/jenkins/m2', mountPath: '/root/.m2'), hostPathVolume(hostPath: '', mountPath: '/usr/share/maven/ref')],
    workspaceVolume: hostPathWorkspaceVolume(hostPath: "/home/jenkins/agent") //持久化工作目录
) {
    properties([
        parameters([
            gitParameter(branch: '',
                        branchFilter: 'origin/(.*)',
                        defaultValue: 'master',
                        description: '选择分支',
                        name: 'Name',
                        type: 'PT_BRANCH',
                        useRepository: '.*process-service.git')
        ])
    ])
    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        withEnv([
            'REPO_HTTP=http://10.4.56.155/maojinglei/finance-process-service.git',
            'GIT_AUTH_ID=ea2f709f-9cac-4978-aeb2-9fc37e8e9667',
            'HARBOR_ADDRESS=myregistry.io:8088',
            'HARBOR_AUTH=credentials("harborAuth")',
            'IMAGE_NAME=my-test-java'
            ]){
            checkout scm
            stage('单元测试'){
                echo "测试阶段"
            }
            stage('克隆代码') {
                println "开始对分支 ${params.Name} 进行构建"
                //检出指定分支代码
                dir('project'){
                    git branch: "${params.Name}", credentialsId: "${GIT_AUTH_ID}", url: "${REPO_HTTP}"
                    script {
                        COMMIT_ID = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                        TAG = "${params.Name}" + '-' + COMMIT_ID
                    }
                }
                println "Current branch is ${params.Name}, Commit ID is ${COMMIT_ID}, Image TAG is ${TAG}"
            }
            stage('Maven编译打包') {
                container('maven') {
                    sh '''
                    cd project
                    mvn -B -ntp clean package -DskipTests
                    '''
                }
            }
            // Archive the built artifacts
            //archive (includes: 'pkg/*.gem')
        }   
    }
}