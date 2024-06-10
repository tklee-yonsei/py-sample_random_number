# 베이스 이미지로 Python 사용
FROM python:3.9-slim

# 작업 디렉토리 설정
WORKDIR /app

# Python 스크립트 실행 명령어 설정
CMD ["python", "random_number.py"]
