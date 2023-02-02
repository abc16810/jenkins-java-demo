//scripts pipeline
podTemplate(yaml: readTrusted('pod.yaml'), containers: [
    containerTemplate(name: 'maven', image: 'myregistry.io:8088/library/maven:3.8.1-jdk-8', command: 'sleep', args: '99d')],
    volumes: [hostPathVolume(hostPath: '/home/jenkins/m2', mountPath: '/root/.m2')],
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
        ]),
        //构建历史
        buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '30', numToKeepStr: '10'))
    ])


    node(POD_LABEL) {   //POD_LABEL 生成的唯一标签
        withEnv([
            'REPO_HTTP=http://10.4.56.155/maojinglei/finance-process-service.git',
            'GIT_AUTH_ID=ea2f709f-9cac-4978-aeb2-9fc37e8e9667',
            'HARBOR_ADDRESS=myregistry.io:8088',
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
            // stage('Maven编译打包') {
            //     container('maven') {
            //         sh '''
            //         cd project
            //         # mvn clean package -Dmaven.test.skip=true
            //         mvn -B -ntp clean package -DskipTests
            //         '''
            //     }
            // }
            stage("构建docker镜像"){
                container('nerdctl') {   //指定容器
                    withCredentials([usernamePassword(credentialsId: 'harborAuth', passwordVariable: 'HARBOR_PASSWORD', usernameVariable: 'HARBOR_USER')]) {
                        sh '''
                        set +x
                        cd project && id && pwd
                        update-ca-certificates
                        nerdctl login -u ${HARBOR_USER} -p ${HARBOR_PASSWORD}  ${HARBOR_ADDRESS}
                        '''
                        sh "ls -l && nerdctl build  -t ${HARBOR_ADDRESS}/library/${IMAGE_NAME}:${TAG} ."
                        sh "nerdctl push ${HARBOR_ADDRESS}/library/${IMAGE_NAME}:${TAG}"
                    }
                }
            }
            stage('Deploying to K8s') {
                if ( params.Name == 'main' || params.Name == 'master'){
                    input "确认要部署线上环境吗？"
                }
                steps {
                    container('kubectl') {
                        sh "sed -i 's/<BUILD_TAGS>/${TAG}/' rc.yaml"   //更新镜像tag
                        sh '''
                        PATH=/opt/bitnami/kubectl/bin:$PATH   # assign path
                        kubectl get pod
                        # kubectl apply -f rc.yaml
                        '''
                }
            }
        }

            // Archive the built artifacts
            //archive (includes: 'pkg/*.gem')
            stage("归档"){
                archiveArtifacts artifacts: 'project/target/*.jar', followSymlinks: false, onlyIfSuccessful: true
            }
            
        }   
    }
}