# Custom shell functions

# Check which process is using a port
# Usage: checkport 8788         (single port)
#        checkport 8788 8798    (range)
checkport() {
    if [ -z "$1" ]; then
        echo "Usage: checkport <port> [end_port]"
        return 1
    fi
    local start_port=$1
    local end_port=${2:-$1}
    for port in $(seq $start_port $end_port); do
        local result=$(lsof -i :$port 2>/dev/null | grep LISTEN)
        if [ -n "$result" ]; then
            echo "Port $port: IN USE"
            echo "$result" | awk '{printf "  → %s (PID %s)\n", $1, $2}'
        else
            echo "Port $port: available"
        fi
    done
}
