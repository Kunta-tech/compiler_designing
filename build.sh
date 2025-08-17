#!/bin/bash

# Name: build.sh
# Usage:
#   ./build.sh -a                # Compile all .c files in all folders
#   ./build.sh -d <folder_name>  # Compile only in a specific folder
#   ./build.sh -f <file_name>	 # Compile only in a specific file
#   ./build.sh -r		         # Remove previous build/

OUTPUT_DIR="build"
mkdir -p "$OUTPUT_DIR"

MAX_JOBS=$(nproc 2>/dev/null || echo 4)  # Use number of CPU cores, default 4
job_count=0

compile_file() {
    local file="${1#./}"
    local directory="$OUTPUT_DIR/$(dirname "$file")"
    local filename="$directory/$(basename "$file" .${file##*.})"

    mkdir -p "$directory"

    case "$file" in
        *.c)
            if gcc "$file" -o "$filename"; then
                echo "✅ Compiled $file → $filename"
            else
                echo "❌ Compilation failed for $file"
                exit 1
            fi
            ;;
        *.l)
            local cfile="$directory/$(basename "$file" .l).c"
            # Run lex to generate C file
            if lex -o "$cfile" "$file"; then
                echo "🌀 Lex generated $cfile"
                if gcc "$cfile" -ll -o "$filename"; then
                    echo "✅ Compiled $file → $filename"
                else
                    echo "❌ Compilation failed for $file"
                    exit 1
                fi
            else
                echo "❌ Lex failed for $file"
                exit 1
            fi
            ;;
    esac
}

run_with_fork() {
    for file in "$@"; do
        compile_file "$file" &  # fork process
        ((job_count++))

        # Limit concurrent jobs
        if (( job_count >= MAX_JOBS )); then
            wait -n
            ((job_count--))
        fi
    done

    wait
}

if [[ "$1" == "-a" ]]; then
    echo "🔍 Searching for all .c files..."
    mapfile -t files < <(find . -type f)
    run_with_fork "${files[@]}"

elif [[ "$1" == "-d" && -n "$2" ]]; then
    if [[ -d "$2" ]]; then
        echo "📂 Compiling files in folder: $2"
        mapfile -t files < <(find "$2" -type f)
        run_with_fork "${files[@]}"
    else
        echo "❌ Folder '$2' not found."
        exit 1
    fi
elif [[ "$1" == "-f" && -n "$2" ]]; then
    if [[ -f "$2" ]]; then
	echo "📂 Compiling file: $2"
	run_with_fork "$2"
    else
	echo "❌ couldn't compile: $2"
	exit 1
    fi
elif [[ "$1" == "-r" ]]; then
    rm -r build
else
    echo "Usage:"
    echo "  $0 -a                Compile all .c files in all folders"
    echo "  $0 -d <folder_name>  Compile only in a specific folder"
    echo "  $0 -f <file_name>	 Compile only in a specific file"
    echo "  $0 -r		 Remove previous build/"
    exit 1
fi
