#!/usr/bin/env bash
set -e
echo "=== Environment Dump ==="
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS: $NAME $VERSION ($(uname -m))"
elif [ "$(uname)" = "Darwin" ]; then
    echo "OS: macOS $(sw_vers -productVersion 2>/dev/null || echo unknown) ($(uname -m))"
else
    echo "OS: $(uname -a 2>/dev/null || echo unknown)"
fi

# tools
for tool in cmake ninja make git python3 curl tar gzip; do
    if command -v $tool &>/dev/null; then
        echo "  $tool: $(command -v $tool)  ($($tool --version 2>&1 | head -1))"
    else
        echo "  $tool: NOT FOUND"
    fi
done

# macOS specific
if [ "$(uname)" = "Darwin" ]; then
    echo "  sw_vers: $(sw_vers -productVersion 2>/dev/null || echo unknown)"
    for tool in xcodebuild autoconf automake libtool pkg-config; do
        if command -v $tool &>/dev/null; then
            echo "  $tool: $(command -v $tool)  ($($tool --version 2>&1 | head -1))"
        else
            echo "  $tool: NOT FOUND"
        fi
    done
fi

# compiler
for cc in gcc g++ clang clang++ cc c++; do
    if command -v $cc &>/dev/null; then
        echo "  $($cc --version 2>&1 | head -1)"
        break
    fi
done
echo "=== End ==="
