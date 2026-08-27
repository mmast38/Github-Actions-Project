# Stage 1: Build the Maven application
FROM maven:3.9-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy the pom.xml and source code into the image
COPY pom.xml .
COPY src ./src

# Compile and package the application (skipping tests to speed up the pipeline)
RUN mvn clean package -DskipTests

# Stage 2: Create the final runtime image
FROM eclipse-temurin:17-jdk-alpine

EXPOSE 8080

ENV APP_HOME=/usr/src/app
WORKDIR $APP_HOME

# Copy the compiled jar from the first build stage
COPY --from=build /app/target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
