#!/usr/bin/env node

// Example of using API4AI brand recognition.
const fs = require('fs')
const path = require('path')
const axios = require('axios').default
const FormData = require('form-data')

// Use 'demo' mode just to try api4ai for free. Free demo is rate limited.
// For more details visit:
//   https://api4.ai

// Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
// For more details visit:
//   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
const MODE = 'demo'

// Your RapidAPI key. Fill this variable with the proper value if you want
// to try api4ai via RapidAPI marketplace.
const RAPIDAPI_KEY = ''

const OPTIONS = {
  demo: {
    url: 'https://demo.api4ai.cloud/brand-det/v2/results?detailed=True',
    headers: { 'A4A-CLIENT-APP-ID': 'sample' }
  },
  rapidapi: {
    url: 'https://brand-recognition.p.rapidapi.com/v2/results?detailed=True',
    headers: { 'X-RapidAPI-Key': RAPIDAPI_KEY }
  }
}

// Parse args: path or URL to image.
const image = process.argv[2] || 'https://storage.googleapis.com/api4ai-static/samples/brand-det-2.jpg'

// Preapare request: form.
const form = new FormData()
if (image.includes('://')) {
  // Data from image URL.
  form.append('url', image)
} else {
  // Data from local image file.
  const fileName = path.basename(image)
  form.append('image', fs.readFileSync(image), fileName)
}

// Preapare request: headers.
const headers = {
  ...OPTIONS[MODE].headers,
  ...form.getHeaders(),
  'Content-Length': form.getLengthSync()
}

// Make request.
axios.post(OPTIONS[MODE].url, form, { headers })
  .then(function (response) {
    // Print raw response.
    console.log(`💬 Raw response:\n${JSON.stringify(response.data)}\n`)
    // Parse response and print recognized brands.
    const brands = response.data.results[0].entities[0].array
    console.log(`💬 Recognized brands:`)
    for (const b of brands) {
      console.log(`  - ${b.name}: ${b.size_category}`)
    }
  })
