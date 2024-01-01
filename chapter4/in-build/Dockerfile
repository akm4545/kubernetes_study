#가장 이미지 용량이 커지는 방식
FROM openjdk:8
LABEL description="Echo IP Java Application"
EXPOSE 60433
#깃에서 이미지 내려받기
RUN git clone https://github.com/iac-source/inbuilder.git
#작업 공간 변경 cd 같은 느낌
WORKDIR inbuilder
RUN chmod 700 mvnw
#자바 파일 빌드
RUN ./mvnw clean package
#빌드 후 옮김
RUN mv target/app-in-host.jar /opt/app-in-image.jar
WORKDIR /opt
ENTRYPOINT ["java", "-jar", "app-in-image.jar"]