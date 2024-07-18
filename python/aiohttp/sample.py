#!/usr/bin/env python3

"""Example of using API4AI brand recognition."""

import asyncio
import sys

import aiohttp


# Use 'demo' mode just to try api4ai for free. Free demo is rate limited.
# For more details visit:
#   https://api4.ai
#
# Use 'rapidapi' if you want to try api4ai via RapidAPI marketplace.
# For more details visit:
#   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
MODE = 'demo'


# Your RapidAPI key. Fill this variable with the proper value if you want
# to try api4ai via RapidAPI marketplace.
RAPIDAPI_KEY = ''


OPTIONS = {
    'demo': {
        'url': 'https://demo.api4ai.cloud/brand-det/v2/results?detailed=True',
        'headers': {'A4A-CLIENT-APP-ID': 'sample'}
    },
    'rapidapi': {
        'url': 'https://brand-recognition.p.rapidapi.com/v2/results?detailed=True',
        'headers': {'X-RapidAPI-Key': RAPIDAPI_KEY}
    }
}


async def main():
    """Entry point."""
    image = sys.argv[1] if len(sys.argv) > 1 else 'https://storage.googleapis.com/api4ai-static/samples/brand-det-2.jpg'

    async with aiohttp.ClientSession() as session:
        if '://' in image:
            # Data from image URL.
            data = {'url': image}
        else:
            # Data from local image file.
            data = {'image': open(image, 'rb')}
        # Make request.
        async with session.post(OPTIONS[MODE]['url'],
                                data=data,  # noqa
                                headers=OPTIONS[MODE]['headers']) as response:
            resp_json = await response.json()
            resp_text = await response.text()

        # Print raw response.
        print(f'💬 Raw response:\n{resp_text}\n')

        # Parse response and print recognized brands.
        brands = resp_json['results'][0]['entities'][0]['array']

        print(f'💬 Recognized brands:')
        for b in brands:
            print(f'  - {b["name"]}: {b["size_category"]}')


if __name__ == '__main__':
    # Run async function in asyncio loop.
    asyncio.run(main())
