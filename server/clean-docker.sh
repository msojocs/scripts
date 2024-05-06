#!/bin/bash

# 设置日志文件的最大大小（例如：10M）
MAX_LOG_SIZE="10M"

# 获取所有Docker容器的日志文件路径
logs=$(find /var/lib/docker/containers/ -name *-json.log)

# 遍历日志文件
for log in $logs; do
    # 检查文件大小是否超过限制
    if [[ $(du -sh "$log" | cut -f1) > $MAX_LOG_SIZE ]]; then
        echo "Truncating $log"
        # 截断日志文件
        cat /dev/null > "$log"
    fi
done

echo "Docker logs cleanup completed."