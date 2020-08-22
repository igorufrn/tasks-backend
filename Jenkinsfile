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
    }
}