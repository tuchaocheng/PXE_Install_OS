#!/bin/bash
# start.sh

# 检测可用资源
CPU_CORES=$(nproc)
TOTAL_MEM_MB=$(free -m | awk '/^Mem:/{print $2}')
# 如果是 cgroup v2 容器，取限制值
CGROUP_MEM=$(cat /sys/fs/cgroup/memory.max 2>/dev/null)
if [ -n "$CGROUP_MEM" ] && [ "$CGROUP_MEM" != "max" ]; then
    TOTAL_MEM_MB=$((CGROUP_MEM / 1024 / 1024))
fi

# 根据资源计算 MPM 参数
START_SERVERS=$((CPU_CORES))
[ $START_SERVERS -lt 2 ] && START_SERVERS=2
[ $START_SERVERS -gt 8 ] && START_SERVERS=8

SERVER_LIMIT=$((CPU_CORES * 4))
[ $SERVER_LIMIT -lt 4 ] && SERVER_LIMIT=4
[ $SERVER_LIMIT -gt 32 ] && SERVER_LIMIT=32

THREADS_PER_CHILD=64
MAX_WORKERS=$((SERVER_LIMIT * THREADS_PER_CHILD))

echo  > /etc/httpd/conf.modules.d/00-mpm.conf 
# 生成 MPM 配置
cat > /etc/httpd/conf.modules.d/00-mpm.conf << EOF
LoadModule mpm_event_module modules/mod_mpm_event.so

<IfModule mpm_event_module>
    StartServers             ${START_SERVERS}
    ServerLimit              ${SERVER_LIMIT}
    MinSpareThreads          75
    MaxSpareThreads          250
    ThreadsPerChild          ${THREADS_PER_CHILD}
    MaxRequestWorkers        ${MAX_WORKERS}
    MaxConnectionsPerChild   0
</IfModule>
EOF

