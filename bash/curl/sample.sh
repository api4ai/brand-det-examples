#!/bin/bash


# Use 'normal' mode if you have an API Key from the API4AI Developer Portal. This is the method that users should normally prefer.
#
# Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
# For more details visit:
#   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
MODE="normal"

# Your API4AI key. Fill this variable with the proper value if you have one.
API4AI_KEY=""

# Your RapidAPI key. Fill this variable with the proper value if you want
# to try api4ai via RapidAPI marketplace.
RAPIDAPI_KEY=""



# Define URL and headers.
if [[ "${MODE}" == "normal" ]]; then
    URL="https://api4ai.cloud/brand-det/v2/results?detailed=True"
    HEADERS="X-API-KEY: ${API4AI_KEY}"
elif [[ "${MODE}" == "rapidapi" ]]; then
    URL="https://brand-recognition.p.rapidapi.com/v2/results?detailed=True"
    HEADERS="X-RapidAPI-Key: ${RAPIDAPI_KEY}"
else
    echo "Unsupported sample mode"
    exit 1
fi


# Path or URL to image.
IMAGE=${1:-"https://static.api4.ai/samples/brand-det-2.jpg"}

# POST.
if [[ "${IMAGE}" =~ "://" ]]; then
    # POST image via URL.
    curl -s -X POST -H "${HEADERS}" "${URL}" -F "url=${IMAGE}"
else
    # POST image as file.
    curl -s -X POST -H "${HEADERS}" "${URL}" -F "image=@${IMAGE}"
fi
