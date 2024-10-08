#!/bin/bash

APP_NAME=
SERVER_SETTING_FILE_PATH=
START_PORT=

echo "Define SERVER_PORT ${START_PORT}" | sudo tee $SERVER_SETTING_FILE_PATH

nohup java -jar ${APP_NAME}.jar --spring.profiles.active=prod --server.port=${START_PORT}

