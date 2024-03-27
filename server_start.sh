APP_NAME=애플리케이션명
echo "> APP_NAME : $APP_NAME"


echo "> 현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -f $APP_NAME)

echo "CURRENT_PID : $CURRENT_PID"

if [ -z $CURRENT_PID ]; then
    echo "> 현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $CURRENT_PID"
    kill -15 $CURRENT_PID
fi

# 이전 애플리케이션이 완전히 종료될 때까지 기다립니다.
while [ -n "$(pgrep -f $APP_NAME)" ]
do
    echo "> 이전 애플리케이션이 종료되기를 기다리는 중..."
    sleep 1
done

echo "> 새 애플리케이션 배포"

rm nohup.out
nohup java -jar "$APP_NAME.jar" --spring.profiles.active=prod & 
sleep 3
tail -f nohup.out
