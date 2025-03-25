#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Initialize counters
TOTAL=0
PASSED=0
FAILED=0

# Clean up output directory (if it exists) and create it again
echo -e "${BOLD}Cleaning up output directory...${NC}"
rm -rf output/*

# Function to run a test and track its result
run_test() {
    local test_script=$1
    local test_name=$(basename "$test_script" .sh | sed 's/test_//')
    
    echo -e "\n${BOLD}Running $test_name test...${NC}"
    TOTAL=$((TOTAL + 1))
    
    # Make the test script executable
    chmod +x "$test_script"
    
    # Run the test
    if bash "$test_script"; then
        echo -e "${GREEN}✓ $test_name test passed${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗ $test_name test failed${NC}"
        FAILED=$((FAILED + 1))
    fi
}

# Print header
echo -e "${BOLD}FFmpeg Test Suite${NC}"
echo "===================="

# Create input and output directories if they don't exist
mkdir -p input output

# Check if input video exists
if [ ! -f "input/input.mp4" ]; then
    echo -e "${RED}Error: input/input.mp4 not found${NC}"
    echo "Please place a test video file named 'input.mp4' in the input directory"
    exit 1
fi

# Run all test scripts
for test_script in test_*.sh; do
    if [ "$test_script" != "test_*.sh" ]; then  # Check if any test scripts exist
        run_test "$test_script"
    fi
done

# Print summary
echo -e "\n${BOLD}Test Summary${NC}"
echo "============="
echo -e "Total tests: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

# Set exit code based on test results
if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}${BOLD}Some tests failed${NC}"
    exit 1
fi
