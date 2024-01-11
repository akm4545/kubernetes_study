#기반 이미지 -> 해당 이미지 내부에서 이미지 빌드작업
FROM openjdk:8 
#이미지의 부가 설명
LABEL description="Echo IP Java Application"
#컨테이너 사용 포트
EXPOSE 60431
#호스트에서 컨테이너 이미지로 필요 파일 복사
COPY ./target/app-in-host.jar /opt/app-in-image.jar
#이미지의 작업 위치 변경 (컨테이너 디렉토리)
WORKDIR /opt
#["명령어", "옵션" ..."옵션"]
#컨테이너 구동 시 사용 명령어
ENTRYPOINT ["java", "-jar", "app-in-image.jar"]