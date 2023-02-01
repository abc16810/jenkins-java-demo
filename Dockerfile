FROM myregistry.io:8088/library/openjdk:8-alpine

LABEL Author="wsm" \
      E-mail="value2" 

ENV TZ=Asia/Shanghai

WORKDIR /srv

COPY target/*.jar /srv/project.jar

EXPOSE 8080

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/srv/project.jar"]
# "--spring.profiles.active=prod"

