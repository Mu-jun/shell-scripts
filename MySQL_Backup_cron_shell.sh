# 리눅스 현재 시간을 시간 형식에 맞게 출력한다.
DATE=$(date +%Y_%m_%d_%H_%M_%S)

# MySQL의 .sql파일을 백업할 디렉터리 위치를 지정한다.
DB_BACKUP_DIR=/home/ubuntu/MySQL_Backup/

# DATE 변수의 현재 시간을 출력한다.
echo $DATE

# DB_BACKUP_DIR 변수의 작업할 디렉터리를 출력한다.
echo $DB_BACKUP_DIR

# 백업할 데이터베이스 이름을 지정한다.
DATABASE=test_db

# mysqldump 명령어를 이용해 데이터베이스를 .sql 파일로 저장한다.
mysqldump --login-path=backupUser $DATABASE > $DB_BACKUP_DIR"${DATABASE}_dump_${DATE}".sql

# 백업파일을 저장하는 폴더에서 7일 이전에 생성된 모든 파일을 삭제한다. (하위 디렉터리>까지)
find $DB_BACKUP_DIR -ctime +7 -exec rm -f {} \;
