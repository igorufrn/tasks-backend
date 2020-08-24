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
        stage('Quality Gate do SONAR') {        	
            steps {
            	/*
            	O sleep pode ser evitado com WebHooks do SONAR
            	Este tempo em segundos é calibrado de acordo com o ambiente e 
            	é o tempo necessário para o SONAR processar as regras 
            	associadas ao projeto e informar ao JENKINS se o mesmo deve
            	prosseguir com o pipeline
            	*/  
            	sleep(5)
            	timeout(time: 1, unit: 'MINUTES'){
            		waitForQualityGate abortPipeline: true            	                 
            	}
            }
        }
        stage('Deploy Backend') {
            steps {
            	deploy adapters: [tomcat8(credentialsId: 'TomcatLogin', path: '', url: 'http://localhost:8001/')], contextPath: null, war: 'target/tasks-backend.war'
            }
        }
        stage('Testes de API') {
            steps {
            	/*
            	Evita sobrescrever o binário gerado, executando os 
            	testes e salvando os resultados em um outro diretório!
            	*/            	
            	dir('api-test') {
				    git credentialsId: 'GitHub_Login', url: 'https://github.com/igorufrn/tasks-api-test'
            		sh 'mvn test'
				}
            }
        }
        stage('Deploy Frontend') {
            steps {
            	dir('frontend') {
            		git credentialsId: 'GitHub_Login', url: 'https://github.com/igorufrn/tasks-frontend'
            		sh 'mvn clean package -DskipTests=true'
            		deploy adapters: [tomcat8(credentialsId: 'TomcatLogin', path: '', url: 'http://localhost:8001/')], contextPath: null, war: 'target/tasks.war'
            	}
            }
        }
        stage('Testes Funcionais') {
            steps {
            	/*
            	Evita sobrescrever o binário gerado, executando os 
            	testes funcionais e salvando os resultados em um outro diretório!
            	*/            	
            	dir('functional-test') {
				    git credentialsId: 'GitHub_Login', url: 'https://github.com/igorufrn/tasks-funcional-test'
            		sh 'mvn test'
				}
            }
        }
        stage('Deploy Producao') {
            steps {
            	sh 'docker-compose build'            	            	
            	sh 'docker-compose up -d'
            }
        }
        stage('Health Check') {
            steps {
            	sleep(5)            	            	
            	dir('functional-test') {				    
            		sh 'mvn verify -Dskip.surefire.tests'
				}
            }
        }        
    }
}


