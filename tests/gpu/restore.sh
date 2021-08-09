#!/bin/bash

CRICKET_PATH=$(pwd)/../..
CRICKET_BIN=${CRICKET_PATH}/gpu/cricket
export CUDA_APP_NAME=test_kernel
CUDA_APP=${CRICKET_PATH}/tests/test_kernel
CRICKET_CLIENT=${CRICKET_PATH}/cpu/cricket-client.so
CRICKET_SERVER=${CRICKET_PATH}/cpu/cricket-server.so
CRIU=/home/eiling/tmp/criu/criu/criu

export REMOTE_GPU_ADDRESS=localhost
export CUDA_VISIBLE_DEVICES=0

CRICKET_CKP_DIR=/tmp/cricket-ckp
CRIU_CKP_DIR=/tmp/criu-ckp

sudo killall ${CUDA_APP_NAME}
sudo killall patched_binary
rm -rf /tmp/cricket-ckp/patched_binary

${CRICKET_BIN} restore ${CUDA_APP} &

sleep 1
server_pid=$(pgrep patched_binary)
echo "server pid:" $server_pid

sleep 10

sudo ${CRIU} restore -vvvvvv --tcp-established --shell-job --images-dir ${CRIU_CKP_DIR} -W ${CRIU_CKP_DIR} --action-script ${CRICKET_PATH}/criu-restore-hook.sh -o restore.log 

#sleep 5
#
#kill $server_pid
#
