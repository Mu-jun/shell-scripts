# 웹서버의 애플리케이션 서버설정파일 경로
SERVER_SETTING_FILE_PATH=
# 애플리케이션 이름
APP_NAME=

echo "> 현재 사용중인 Port 확인"
CURRENT_PORT=$(cat ${SERVER_SETTING_FILE_PATH} | grep -Po '[0-9]+' | tail -1)

# 새 Port 설정
if [ ${CURRENT_PORT} -eq 8000 ]
then
  IDLE_PORT=8001
elif [ ${CURRENT_PORT} -eq 8001 ]
then
  IDLE_PORT=8000
else
  echo "> 현재 사용중인 Port를 확인할 수 없습니다."
  echo "> 기본 설정을 적용합니다."

  IDLE_PORT=8000
fi
echo "IDLE_PORT : ${IDLE_PORT}"

echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -f $APP_NAME)

echo "CURRENT_PID : $CURRENT_PID"

echo "> 새 애플리케이션 배포"

nohup java -jar "$APP_NAME.jar" --spring.profiles.active=prod --server.port=${IDLE_PORT} > ${APP_NAME}-${IDLE_PORT}.log 2>&1 &
echo "> nohup java -jar "$APP_NAME.jar" --spring.profiles.active=prod --server.port=${IDLE_PORT} > ${APP_NAME}-${IDLE_PORT}.log 2>&1 &"

echo "> 10초 후 Health check 시작"
echo "> curl -s http://localhost:$IDLE_PORT/check/health "
sleep 10

for retry_count in {1..10}
do
  response=$(curl -s http://localhost:$IDLE_PORT/check/health)

  if [ "${response}" == "UP" ]
  then
    echo "> Health check 성공"
    break
  else
      echo "> Health check의 응답을 알 수 없거나 혹은 status가 UP이 아닙니다."
      echo "> Health check: ${response}"
  fi

  if [ $retry_count -eq 10 ]
  then
    echo "> Health check 실패. "
    echo "> 웹서버에 연결하지 않고 배포를 종료합니다."

    IDLE_PID=$(pgrep -f $APP_NAME | grep -v "$CURRENT_PID")
    echo "IDE_PID : $IDLE_PID"
    if [ -n "$IDLE_PID" ]
    then
      kill -15 $IDLE_PID
    fi
    
    tail -n 1000 ${APP_NAME}-${IDLE_PORT}.log
    exit 1
  fi

  echo "> Health check 연결 실패. 재시도..."
  sleep 10
done

# 웹서버 연결 변경
echo "> 웹서버 설정 파일 변경"
echo "Define SERVER_PORT $IDLE_PORT" | sudo tee $SERVER_SETTING_FILE_PATH

echo "> 웹서버 설정 파일 변경 적용"
sudo service apache2 graceful

echo "> 이전 애플리케이션 종료"
kill -15 $CURRENT_PID

tail -f ${APP_NAME}-${IDLE_PORT}.log
