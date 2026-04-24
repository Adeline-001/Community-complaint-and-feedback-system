# Stage 1: Build the application using Maven
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:10.1-jdk21-temurin-jammy
WORKDIR /usr/local/tomcat/webapps/

# Remove default Tomcat apps to speed up startup
RUN rm -rf ./ROOT ./examples ./docs ./manager ./host-manager

# Disable the shutdown port to prevent Render health-check warnings (hitting port 8005)
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' /usr/local/tomcat/conf/server.xml

# Copy the built WAR from the build stage and rename it to ROOT.war
COPY --from=build /app/target/*.war ./ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
