#stage1 자바 소스 빌드 - jar 파일 생성
#별칭
FROM openjdk:8 AS int-build 
LABEL description="Java Application builder"
RUN git clone https://github.com/iac-source/inbuilder.git
WORKDIR inbuilder
RUN chmod 700 mvnw
RUN ./mvnw clean package

#stage2 
#경량 이미지 사용
FROM gcr.io/distroless/java:8
LABEL description="Echo IP Java Application"
EXPOSE 60434
#stage1 에서 빌드된 자바 파일을 복사하여 가져옴
COPY --from=int-build inbuilder/target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT ["java", "-jar", "app-in-image.jar"]