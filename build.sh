#!/bin/bash

# Name: build.sh
# Usage:
#   ./build.sh -a                # Compile all .c files in all folders
#   ./build.sh -d <folder_name>  # Compile only in a specific folder
#   ./build.sh -r		 # Remove previous build/

OUTPUT_DIR="build"
mkdir -p "$OUTPUT_DIR"

MAX_JOBS=$(nproc 2>/dev/null || echo 4)  # Use number of CPU cores, default 4
job_count=0

compile_file() {
    local file="${1#./}"
    local directory="$OUTPUT_DIR/$(dirname "$file")"
    local filename=$directory/$(basename "$file" .c)
    mkdir -p $directory; 

    if gcc "$file" -o "$filename"; then
        echo "✅ Compiled $file → $filename"
    else
        echo "❌ Compilation failed for $file"
        exit 1
    fi
}

run_with_fork() {
    for file in "$@"; do
        compile_file "$file" &  # fork process
        ((job_count++))

        # Limit concurrent jobs
        if (( job_count >= MAX_JOBS )); then
            wait -n  # wait for any job to finish before starting a new one
            ((job_count--))
        fi
    done

    wait  # wait for all jobs to finish
}

if [[ "$1" == "-a" ]]; then
    echo "🔍 Searching for all .c files..."
    mapfile -t files < <(find . -type f -name "*.c")
    run_with_fork "${files[@]}"

elif [[ "$1" == "-d" && -n "$2" ]]; then
    if [[ -d "$2" ]]; then
        echo "📂 Compiling files in folder: $2"
        mapfile -t files < <(find "$2" -type f -name "*.c")
        run_with_fork "${files[@]}"
    else
        echo "❌ Folder '$2' not found."
        exit 1
    fi
elif [[ "$1" == "-r" ]]; then
    rm -r build
else
    echo "Usage:"
    echo "  $0 -a                Compile all .c files in all folders"
    echo "  $0 -d <folder_name>  Compile only in a specific folder"
    echo "  $0 -r		 Remove previous build/"
    exit 1
fi
