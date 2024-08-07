#!/bin/bash


# Use 'demo' mode just to try api4ai for free. Free demo is rate limited.
# For more details visit:
#   https://api4.ai
#
# Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
# For more details visit:
#   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
MODE="demo"


# Your RapidAPI key. Fill this variable with the proper value if you want
# to try api4ai via RapidAPI marketplace.
RAPIDAPI_KEY=""



# Define URL and headers.
if [[ "${MODE}" == "demo" ]]; then
    URL="https://demo.api4ai.cloud/brand-det/v2/results?detailed=True"
    HEADERS="A4A-CLIENT-APP-ID: sample"  # optional header
elif [[ "${MODE}" == "rapidapi" ]]; then
    URL="https://brand-recognition.p.rapidapi.com/v2/results?detailed=True"
    HEADERS="X-RapidAPI-Key: ${RAPIDAPI_KEY}"
else
    echo "Unsupported sample mode"
    exit 1
fi


# Path or URL to image.
IMAGE=${1:-"https://storage.googleapis.com/api4ai-static/samples/brand-det-2.jpg"}

# POST.
if [[ "${IMAGE}" =~ "://" ]]; then
    # POST image via URL.
    curl -s -X POST -H "${HEADERS}" "${URL}" -F "url=${IMAGE}"
else
    # POST image as file.
    curl -s -X POST -H "${HEADERS}" "${URL}" -F "image=@${IMAGE}"
fi
