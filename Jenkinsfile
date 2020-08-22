pipeline {
    agent any
    stages{
        stage('Build Backend') {
            steps {
            	/*
                Pelo ciclo de vida do maven, antes de executar um package, 
                o mesmo executa a fase de test do maven.
                Mas como quero separar estas etapas, segue a seguinte configuração.
                Limpar, empacotar, mas não execute testes!
                */
                sh 'mvn clean package -DskipTests=true'
            }
        }        
        stage('Testes unitários') {
            steps {            	
                sh 'mvn test'
            }
        }
        stage('Análise estática do SONAR') {
        	environment{
        	    scannerHome = tool 'SONAR_SCANNER'
        	}
            steps {
            	withSonarQubeEnv('SONAR_LOCAL'){
            		//Aspas duplas, pois quero fazer interpolação de variáveis            	
                	sh "${scannerHome}/bin/sonar-scanner -e -Dsonar.projectKey=DeployBack -Dsonar.host.url=http://localhost:9000 -Dsonar.login=05f6f45d5101d96e112350ac7942c1662b47b0d3 -Dsonar.java.binaries=target -Dsonar.coverage.exclusions=**/.mvn/**,**/src/test/**,**/model/**,**Application.java"
            	}            	
            }
        }
    }
}