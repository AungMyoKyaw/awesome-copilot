#!/bin/bash
# Script to fix line endings in all markdown files
# Usage: ./scripts/fix-line-endings.sh [--check]
#   --check: Only check for CRLF line endings, do not modify files

set -e

CHECK_ONLY=false
if [[ "$1" == "--check" ]]; then
  CHECK_ONLY=true
fi

echo "Normalizing line endings in markdown files..."

# Counter for modified/checked files
count=0
crlf_found=0

# Find all markdown files and convert CRLF to LF
while IFS= read -r -d '' file; do
  if [[ "$CHECK_ONLY" == true ]]; then
    if grep -q $'\r' "$file"; then
      echo "CRLF found in: $file"
      ((crlf_found++))
    fi
  else
    # Convert CRLF to LF in place
    if sed -i '' 's/\r$//' "$file" 2>/dev/null || sed -i 's/\r$//' "$file" 2>/dev/null; then
      ((count++))
    fi
  fi
done < <(find . -name "*.md" -type f -print0)

if [[ "$CHECK_ONLY" == true ]]; then
  if [[ $crlf_found -gt 0 ]]; then
    echo "Found $crlf_found file(s) with CRLF line endings"
    exit 1
  else
    echo "All markdown files have correct LF line endings"
    exit 0
  fi
else
  echo "Done! Processed $count markdown files. All now have LF line endings."
fi
