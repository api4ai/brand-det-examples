#!/usr/bin/env php

<?php
// Example of using API4AI brand recognition.

// Use 'normal' mode if you have an API Key from the API4AI Developer Portal. This is the method that users should normally prefer.
//
// Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
// For more details visit:
//   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
$MODE = 'normal';

// Your API4AI key. Fill this variable with the proper value if you have one.
$API4AI_KEY = null;

// Your RapidAPI key. Fill this variable with the proper value if you want
// to try api4ai via RapidAPI marketplace.
$RAPIDAPI_KEY = null;

$OPTIONS = [
    'normal' => [
        'url' => 'https://api4ai.cloud/brand-det/v2/results?detailed=True',
        'headers' => ["X-API-KEY: {$API4AI_KEY}"]
    ],
    'rapidapi' => [
        'url' => 'https://brand-recognition.p.rapidapi.com/v2/results?detailed=True',
        'headers' => ["X-RapidAPI-Key: {$RAPIDAPI_KEY}"]
    ]
];

// Initialize request session.
$request = curl_init();

// Check if path to local image provided.
$data = ['url' => 'https://static.api4.ai/samples/brand-det-2.jpg'];
if (array_key_exists(1, $argv)) {
    if (strpos($argv[1], '://')) {
        $data = ['url' => $argv[1]];
    } else {
        $filename = pathinfo($argv[1])['filename'];
        $data = ['image' => new CURLFile($argv[1], null, $filename)];
    }
}

// Set request options.
curl_setopt($request, CURLOPT_URL, $OPTIONS[$MODE]['url']);
curl_setopt($request, CURLOPT_HTTPHEADER, $OPTIONS[$MODE]['headers']);
curl_setopt($request, CURLOPT_POST, true);
curl_setopt($request, CURLOPT_POSTFIELDS, $data);
curl_setopt($request, CURLOPT_RETURNTRANSFER, true);

// Execute request.
$result = curl_exec($request);

// Decode response.
$raw_response = json_decode($result, true);

// Print raw response.
echo join('',
          ["💬 Raw response:\n",
           json_encode($raw_response),
           "\n"]);

// Parse response and print recognized brands.
$brands = $raw_response['results'][0]['entities'][0]['array'];

// Close request session.
curl_close($request);

// Print recognized brands.
echo "\n💬 Recognized brands:\n";
foreach ($brands as $brand) {
    echo "  - {$brand['name']}: {$brand['size_category']}\n";
}
?>
