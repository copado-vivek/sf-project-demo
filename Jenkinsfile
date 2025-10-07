pipeline {
    agent any
    environment {
        SF_CONSUMER_KEY = "${env.SF_CONSUMER_KEY}"
        SF_USERNAME = "${env.SF_USERNAME}"
        SF_INSTANCE_URL = "${env.SF_INSTANCE_URL ?: 'https://login.salesforce.com'}"
    }
    tools {
        // You MUST configure a NodeJS tool in Jenkins > Manage Jenkins > Global Tool Configuration
        // with the name 'NodeJS 18.x' for this pipeline to work.
        nodejs 'NodeJS 24.x'
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH.replaceFirst('origin/', '')
                    echo "Checking branch name..."
                    echo "Current branch: ${branchName}"
                }
            }
        }
        stage('Install Node.js') {
            steps {
                echo 'Node.js is ready to use.'
            }
        }
        stage('Install Salesforce CLI') {
            steps {
                //sh 'npm install sfdx-cli -g'
                sh 'npm install --global @salesforce/cli'
                sh 'sf --version'
            }
        }
        stage('Debug JWT Key File') {
            steps {
                echo 'This stage would typically verify the presence of a JWT key file.'
            }
        }
        stage('Authorize Salesforce Org') {
            steps {
                withCredentials([file(credentialsId: 'SF_SERVER_KEY', variable: 'server_key_file')]) {
                    sh '''
                        echo "***************************************"
                        cat "${server_key_file}"
                        echo "***************************************"
                    '''

                    sh '''
                        sfdx force:auth:jwt:grant \\
                          --clientid ''' + SF_CONSUMER_KEY + ''' \\
                          --jwtkeyfile ''' + server_key_file + ''' \\
                          --username ''' + SF_USERNAME + ''' \\
                          --instanceurl ''' + SF_INSTANCE_URL + '''
                    '''
                }
            }
        }
        // stage('Run PMD Analysis') {
        //     steps {
        //         tool 'JDK 11'
        //         sh '''
        //             curl -L -o pmd.zip https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.55.0/pmd-bin-6.55.0.zip
        //             # The fix is here: Added the -o flag to unzip
        //             unzip -o -q pmd.zip
        //         '''
        //         sh '''
        //             mkdir -p pmd-reports
        //             ./pmd-bin-6.55.0/bin/run.sh pmd \\
        //               -d force-app/main/default/classes \\
        //               -R apex-ruleset.xml \\
        //               -f html \\
        //               -r pmd-reports/pmd-report.html
        //         '''
        //         archiveArtifacts artifacts: 'pmd-reports/**'
        //     }
        // }
        // 
        
        //-------------------------------------------------------------------------
        // Run unit tests in test scratch org.
        // -------------------------------------------------------------------------
        
        // stage('Run Tests In Test Scratch Org') {
        //     rc = command "${toolbelt}/sf apex run test --target-org ciorg --wait 10 --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
        //     if (rc != 0) {
        //         error 'Salesforce unit test run in test scratch org failed.'
        //     }
        // }
        stage('Deploy Custom Object') {
            steps {
                echo 'This stage would deploy the custom object.'
                sh 'mkdir -p toDeploy'
                sh 'sfdx force:source:convert -d toDeploy -x manifest/package.xml'
                sh '''
                    sfdx force:mdapi:deploy \\
                      -u ''' + SF_USERNAME + ''' \\
                      -d ./toDeploy \\
                      -l NoTestRun \\
                      -w 10
                '''
            }
        }
    }
    post {
        failure {
            echo 'Pipeline failed.'
        }
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}


// pipeline {
//   agent any
//   stages {
//     stage('Checkout') {
//       steps {
//         checkout scm
//       }
//     }
//     stage('Install SFDX') {
//       steps {
//         sh 'npm install sfdx-cli --global'
//       }
//     }
//     stage('Static Analysis') {
//       steps {
//         sh 'sfdx force:source:lint || true' // or PMD scan
//       }
//     }
//     stage('Validate Deployment') {
//       steps {
//         sh 'sf project deploy start --checkonly --target-org ciOrg'
//       }
//     }
//   }
// }
