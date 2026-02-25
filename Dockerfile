# DAY2
#FROM eclipse-temurin:17-jre
#WORKDIR /app
#COPY target/*.jar app.jar
#EXPOSE 8080
#ENTRYPOINT ["java","-jar","app.jar"]

FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -Dmaven.test.skip=true clean package

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]