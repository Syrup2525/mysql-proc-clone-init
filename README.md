# Node.js 기반 MySQL Stored Procedure 복제

### 모든 Stored Procedure 를 다른 이름으로 복제합니다.

예를들어 다음과 같은 프로시저 목록이 있다고 가정하면
- Stored_Procedure1
- Stored_Procedure2
- Stored_Procedure3
- Stored_Procedure4

결과는 다음과 같이 됩니다.
- Stored_Procedure1 (기존)
- Stored_Procedure1_v0_13_1 (신규) (Stored_Procedure1 내용 복제)
- Stored_Procedure2 (기존)
- Stored_Procedure2_v0_13_1 (신규) (Stored_Procedure2 내용 복제)
- Stored_Procedure3 (기존)
- Stored_Procedure3_v0_13_1 (신규) (Stored_Procedure3 내용 복제)
- Stored_Procedure4 (기존)
- Stored_Procedure4_v0_13_1 (신규) (Stored_Procedure4 내용 복제)

---

### 사용 방법

1. 프로젝트 최상단 디렉터리에 .env 파일을 생성하고 다음과 같이 작성합니다
- 모든 프로시저를 `v0_13_1` 로 복제하는 예시입니다.

``` txt
MYSQL_HOST=mysql.example.com
MYSQL_PORT=3306
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_DATABASE=somedatabase

VERSION_SUFFIX=_v0_13_0
```

2. Docker Container 를 build 합니다.
``` bash
docker build -t proc-cloner . 
```

3. Container 를 실행합니다.
``` bash
docker run --rm --env-file .env -v "$(pwd)/output:/tmp" proc-cloner
```