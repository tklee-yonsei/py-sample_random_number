#!/bin/bash

# 변수 설정
REMOTE_USER="tklee"
REMOTE_HOST="navis3.iptime.org"
REMOTE_PORT="8027"
REMOTE_DIR="~/py-sample_random_number"
LOCAL_DIR="$HOME/workspace/code_study/aimimo/py-sample_random_number/"
DOCKER_IMAGE="random_num_sample_img"
DOCKER_CONTAINER_NAME="random_num_container_01"

# 파일 전송
echo "원격 서버로 파일 전송 중..."
rsync -avz -e "ssh -p ${REMOTE_PORT}" ${LOCAL_DIR} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}

# 원격 서버에서 Docker 컨테이너 실행
echo "원격 서버에서 Docker 컨테이너 실행 중..."
ssh -p ${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} << EOF
    cd ${REMOTE_DIR}
    
    if ! docker images | grep -q ${DOCKER_IMAGE}; then
        echo "이미지 빌드 중..."
        docker build -t ${DOCKER_IMAGE} .
    else
        echo "이미지가 이미 존재합니다. 빌드를 건너뜁니다."
    fi

    if [ \$(docker ps -a -q -f name=${DOCKER_CONTAINER_NAME}) ]; then
        echo "존재하는 컨테이너 멈추고 제거 중..."
        docker stop ${DOCKER_CONTAINER_NAME}
        docker rm ${DOCKER_CONTAINER_NAME}
    fi

    echo "원격 서버에서 Docker 컨테이너를 실행합니다."
    echo "------"
    
    docker run --name ${DOCKER_CONTAINER_NAME} -v ${REMOTE_DIR}:/app ${DOCKER_IMAGE}
EOF
