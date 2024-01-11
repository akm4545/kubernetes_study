# 자바 실행을 위한 경량화 이미지 
# openjdk 의 자바 개발 도구 제외
FROM gcr.io/distroless/java:8
LABEL description="Echo IP Java Application"
EXPOSE 60432
COPY ./target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT ["java", "-jar", "app-in-image.jar"]