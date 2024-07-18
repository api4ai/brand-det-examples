// Example of using API4AI brand recognition.

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

document.addEventListener('DOMContentLoaded', function (event) {
  const input = document.getElementById('file')
  const raw = document.getElementById('raw')
  const sectionRaw = document.getElementById('sectionRaw')
  const parsed = document.getElementById('parsed')
  const sectionParsed = document.getElementById('sectionParsed')
  const spinner = document.getElementById('spinner')

  input.addEventListener('change', (event) => {
    const file = event.target.files[0]
    if (!file) {
      return false
    }

    sectionRaw.hidden = true
    sectionParsed.hidden = true
    spinner.hidden = false

    // Preapare request.
    const form = new FormData()
    form.append('image', file)
    const requestOptions = {
      method: 'POST',
      body: form,
      headers: OPTIONS[MODE].headers
    }

    // Make request.
    fetch(OPTIONS[MODE].url, requestOptions)
      .then(response => response.json())
      .then(function (response) {
        // Print raw response.
        raw.textContent = JSON.stringify(response, undefined, 2)
        sectionRaw.hidden = false
        // Parse response and print recognized brands.
        const brands = response.results[0].entities[0].array
        if (brands.length > 0) {
          parsed.textContent = ''
          for (const b of brands) {
            parsed.textContent += `- ${b["name"]}: ${b["size_category"]}\n`
          }
        }
        else {
          parsed.textContent = 'No brands recognized.'
        }
        sectionParsed.hidden = false
      })
      .catch(function (error) {
        // Error can be handled here.
        console.error(error)
      })
      .then(function () {
        spinner.hidden = true
      })
  })
})
