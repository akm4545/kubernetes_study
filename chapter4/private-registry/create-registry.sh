#자체 서명 인증서를 사용한 도커 레지스트리 사용
#!/usr/bin/env bash
certs=/etc/docker/certs.d/192.168.1.10:8443 #변수 설정 레지스트리에 접근할때 사용할 인증서 디텍토리 경로
mkdir /registry-image #레지스트리 이미지 저장 경로
mkdir /etc/docker/certs #레지스트리 서버의 인증서 보관 경로
mkdir -p $certs #인증서 보관 
#인증서를 생성하는 요청서가 담긴 tls.csr 파일로 https 인증서인 tls.crt파일과 암호화 복호화에
#사용하는 키인 tls.key 파일을 생성
openssl req -x509 -config $(dirname "$0")/tls.csr -nodes -newkey rsa:4096 \
-keyout tls.key -out tls.crt -days 365 -extensions v3_req

#ssh접속을 위한 비밀번호를 자동으로 입력하는 sshpass 설치 (자동화를 위함)
yum install sshpass -y 
#인증서 디렉퇴 생성 및 인증서 복사
for i in {1..3}
    do
        sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i mkdir -p $certs
        sshpass -p vagrant scp tls.crt 192.168.1.10$i:$certs
    done

cp tls.crt $certs #인증서 파일 복사
mv tls.* /etc/docker/certs #인증서와 복호화 키 옮김

#레지스트리 컨테이너 실행
docker run -d \
    --restart=always \ 
    --name registry \
    -v /etc/docker/certs:/docker-in-certs:ro \ #인증서를 컨테이너 내부에서 사용할 수 있도록 볼륨 처리 ro = read-only
    -v /registry-imge:/var/lib/registry \ #레지스트리 컨테이너를 새로 구동시켜도 레지스트리 등록 이미지가 계속 남아있을 수 있도록 볼륨 처리
    -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \ #레지스트리 포트 설정
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/docker-in-certs/tls.crt \ #레지스트리가 사용할 https 인증서 경로
    -e REGISTRY_HTTP_TLS_KEY=/docker-in-certs/tls.key \ #데이터 암,복호화 키 경로
    -p 8443:443 \
    registry:2
