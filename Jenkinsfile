pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Install SFDX') {
      steps {
        sh 'npm install sfdx-cli --global'
      }
    }
    stage('Static Analysis') {
      steps {
        sh 'sfdx force:source:lint || true' // or PMD scan
      }
    }
    stage('Validate Deployment') {
      steps {
        sh 'sf project deploy start --checkonly --target-org ciOrg'
      }
    }
  }
}