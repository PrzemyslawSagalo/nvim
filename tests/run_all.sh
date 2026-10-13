#!/bin/bash
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/home/ec2-user/src}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
# we will just run the ones in tests/
FAILURES=0

for test_file in tests/test_*.lua; do
    echo "Running $test_file..."
    if ! nvim --headless -c "lua dofile('$test_file')" -c "q"; then
        echo "FAIL: $test_file"
        FAILURES=$((FAILURES+1))
    fi
done

if [ $FAILURES -gt 0 ]; then
    echo "$FAILURES tests failed"
    exit 1
else
    echo "All tests passed successfully"
    exit 0
fi
