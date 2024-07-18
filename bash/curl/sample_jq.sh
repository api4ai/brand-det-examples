#!/bin/bash

######################################################
# NOTE:                                              #
#   This script requires "jq" command line tool!     #
#   See https://stedolan.github.io/jq/               #
######################################################


IMAGE=${1}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Run base sample script to get raw output.
raw_response=$(bash ${DIR}/sample.sh "${IMAGE}")
echo -e "💬 Raw response:\n${raw_response}\n"

# Parse response and print recognized brands.
echo "💬 Recognized brands:"
jq -r '.results[0].entities[0].array[] | "  - \(.name): \(.size_category)"' <<< ${raw_response}
