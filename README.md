# shell-scripts

유용한 쉘 스크립트 모음

## server_start.sh

- 이전 애플리케이션을 종료하고 새로운 애플리케이션을 시작한다.
- <u>APP_NAME을 수정하여 사용할 것</u>
- 참고 : https://jojoldu.tistory.com/263?category=635883

## nonstop_deploy.sh

- 새 애플리케이션을 시작하고 정상 작동할 경우 웹서버 설정을 변경하여 새 애플리케이션으로 연결한다.
- 새 애플리케이션 시작 실패시 새 애플리케이션을 종료한다.
- 서비스가 사용하는 포트는 8000번과 8001번만 쓴다고 가정한다.
- <u>웹서버 연결 변경 부분은 웹서버에 맞게 수정하여 사용하여야 합니다.</u>
- 참고 : https://jojoldu.tistory.com/267?category=635883

- 참고용 아파치 설정

```
ProxyRequests Off
ProxyPreserveHost On

# Define SERVER_PORT 8000
# Include /etc/apach2 이후 경로 또는 절대 경로
# ex : 변수설정 파일의 경로가 /etc/apache2/service-port.inc 일 경우
Include service-port.inc

<Location />
        ProxyPass  http://localhost:${SERVER_PORT}/
        ProxyPassReverse  http://localhost:${SERVER_PORT}/
</Location>
```
