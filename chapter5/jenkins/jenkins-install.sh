#헬름을 이용한 젠킨스 파드 설치 스크립트

#!/usr/bin/env bash
#변수 설정
#세션 유효기간
jkopt1="--sessionTimeout=1440"
#세션 정리 시간
jkopt2="--sessionEviction=86400"
#젠킨스 시간대 설정
jvopt1="-Duser.timezone=Asia/Seoul"
#젠킨스 설치 노드인 마스터 노드가 재시작하면 젠킨스 설정값이 초기화되므로 설정파일을 yaml에 저장해서 읽어오도록 함
jvopt2="-Dcasc.jenkins.config=https://raw.githubusercontent.com/sysnet4admin/_Book_k8sInfra/main/ch5/5.3.1/jenkins-config.yaml"

#install 릴리스 명(헬름 관련 명령어 수행시 별칭) 레포지토리/차트 명
helm install jenkins edu/jenkins \
#정적 pvc 사용 
--set persistence.existingClaim=jenkins \
#관리자 비밀번호
--set master.adminPassword=admin \
#젠킨스 컨트롤러 설치 노드 -> 노드명(레이블) 확인 후 기입 .앞에 이스케이프 처리
--set master.nodeSelector."kubernetes\.io/hostname"=m-k8s \
#테인트(taints) -> 아무나 접근 못하는 특별한 노드 ex) 마스터 노드, DB노드
#톨러레이션(tolerations) -> 테인트가 설정된 노드에 파드 스케줄링 (설치)을 하기 위한 키
#테인트, 톨러레이션 모드 키=벨류와 효과(effect) 로 이루어져 있으며 툴러레이션에만 키와 벨류, 이펙트를 비교하기 위한
#연산자(operator) 가 존재 [equal, exists]
--set master.tolerations[0].key=node-role.kubernetes.io/master \
--set master.tolerations[0].effect=NoSchedule \
--set master.tolerations[0].operator=Exists \
#젠킨스 구동 파드가 실행될때 가질 유저ID, 그룹ID (리눅스)
--set master.runAsUser=1000 \
--set master.runAsGroup=1000 \
#젠킨스 버전
--set master.tag=2.249.3-lts-centos7 \
#차트로 생성되는 서비스 타입 LoadBalancer = 외부 접근 
--set master.serviceType=LoadBalancer \
--set master.servicePort=80 \
#젠킨스 추가 설정
--set master.jenkinsOpts="$jkopt1 $jkopt2" \
#젠킨스 구동 환경설정
--set master.javaOpts="$jvopt1 $jvopt2 $jvopt3"s