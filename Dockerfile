FROM tomcat:8.5.50-jdk8-openjdk
ARG WAR_FILE
ARG CONTEXT
COPY ${WAR_FILE} /usr/local/tomcat/webapps/${CONTEXT}.war
#COPY frontend/target/tasks.war /usr/local/tomcat/webapps/tasks.war