# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:10.1-jdk17-temurin-alpine
WORKDIR /usr/local/tomcat/webapps/

# Remove default Tomcat apps to speed up startup
RUN rm -rf ./ROOT ./examples ./docs ./manager ./host-manager

# Copy the built WAR from the build stage and rename it to ROOT.war
# This ensures the app is served at the root URL (/)
COPY --from=build /app/target/*.war ./ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
