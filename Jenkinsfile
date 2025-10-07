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
        nodejs 'NodeJS 18.x'
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
                sh 'npm install sfdx-cli -g'
            }
        }
        stage('Debug JWT Key File') {
            steps {
                echo 'This stage would typically verify the presence of a JWT key file.'
            }
        }
        stage('Authorize Salesforce Org') {
            steps {
                withCredentials([file(credentialsId: 'SF_SERVER_KEY', variable: 'sf-jwt-key')]) {
                    sh '''
                        echo "***************************************"
                        cat "${sf-jwt-key}"
                        echo "***************************************"
                    '''

                    sh '''
                        sfdx force:auth:jwt:grant \\
                          --clientid ''' + SF_CONSUMER_KEY + ''' \\
                          --jwtkeyfile ''' + sf-jwt-key + ''' \\
                          --username ''' + SF_USERNAME + ''' \\
                          --instanceurl ''' + SF_INSTANCE_URL + '''
                    '''
                }
            }
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
