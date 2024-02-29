FROM alpine:latest AS BUILD_IMAGE
WORKDIR /usr/src/app/
#RUN apt update && yum install maven -y
#RUN choco install maven -y
RUN apk update && apk add maven 
COPY ./ /usr/src/app/
RUN mvn install -DskipTests

FROM openjdk:latest

WORKDIR /usr/src/app/
COPY --from=BUILD_IMAGE /usr/src/app/target/book-work-0.0.1-SNAPSHOT.jar ./book-work-0.0.1.jar

EXPOSE 9000
ENTRYPOINT ["java","-jar","book-work-0.0.1.jar"]
# Test