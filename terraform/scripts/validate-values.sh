#!/bin/bash

# Validate dev-values files
set -e

echo "🔍 Validating dev-values files..."

VALUES_DIR="../dev-values"
REQUIRED_FILES=(
    "mongodb-dev.yaml"
    "redis-dev.yaml"
    "postgres-dev.yaml"
    "weaviate-dev.yaml"
    "supabase-dev.yaml"
    "temporal-dev.yaml"
    "nginx-dev.yaml"
    "unstructured-dev.yaml"
)

# Check if values directory exists
if [ ! -d "$VALUES_DIR" ]; then
    echo "❌ Values directory $VALUES_DIR not found"
    exit 1
fi

echo "📁 Checking for required value files..."

# Check each required file
missing_files=()
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$VALUES_DIR/$file" ]; then
        echo "✅ $file exists"

        # Basic YAML validation
        if command -v yq &> /dev/null; then
            if yq eval '.' "$VALUES_DIR/$file" &> /dev/null; then
                echo "   ✅ Valid YAML syntax"
            else
                echo "   ❌ Invalid YAML syntax"
                exit 1
            fi
        else
            echo "   ⚠️  yq not installed, skipping YAML validation"
        fi
    else
        echo "❌ $file missing"
        missing_files+=("$file")
    fi
done

# Report results
if [ ${#missing_files[@]} -eq 0 ]; then
    echo ""
    echo "🎉 All required value files are present and valid!"
else
    echo ""
    echo "❌ Missing files:"
    for file in "${missing_files[@]}"; do
        echo "   - $file"
    done
    exit 1
fi

echo ""
echo "📋 Value files validation complete"
