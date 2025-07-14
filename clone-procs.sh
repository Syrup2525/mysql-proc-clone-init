#!/bin/bash
set -e

echo "🎯 프로시저 복제 시작 - 버전 접미사: $VERSION_SUFFIX"

PROCS=$(mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -N -B -e \
  "SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE='PROCEDURE' AND ROUTINE_SCHEMA='${MYSQL_DATABASE}';")

for PROC in $PROCS; do
  echo "🔄 $PROC → ${PROC}${VERSION_SUFFIX}"

  RAW_FILE="/tmp/raw_proc_${PROC}.txt"
  mysql --default-character-set=utf8mb4 \
    -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    -e "SHOW CREATE PROCEDURE \`${MYSQL_DATABASE}\`.\`${PROC}\` \G" > "$RAW_FILE"

  node clone-proc.js "$PROC" "$VERSION_SUFFIX" "$RAW_FILE" "/tmp/create_proc_${PROC}${VERSION_SUFFIX}.sql"
  
  echo "📦 실행 중: /tmp/create_proc_${PROC}${VERSION_SUFFIX}.sql"
  mysql --default-character-set=utf8mb4 \
    -h "$MYSQL_HOST" -P "$MYSQL_PORT" \
    -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    "$MYSQL_DATABASE" < "/tmp/create_proc_${PROC}${VERSION_SUFFIX}.sql"

  echo "✅ ${PROC}${VERSION_SUFFIX} 생성 완료!"
done

echo "🎉 모든 프로시저 복제 완료!"
