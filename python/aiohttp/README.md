# API4AI brand logo recognition sample

This directory contains a minimalistic sample that sends requests to the API4AI Brand Recognition API.
The sample is implemented in `python` using [aiohttp](https://pypi.org/project/aiohttp/) module.


## Overview

Brand Recognition API covers tens of popular brands from different industries. Its output is a bounding box with a logo image inside, logo brand prediction and its confidence level.
It is aimed at a number of applications: it can be integrated into a mobile app or act as a part of a marketing research tool, etc.


## Getting started

Preinstall dependencies before use:

```bash
pip3 install -r requirements.txt
```

Try sample with default args:
```bash
python3 sample.py
```

Try sample with your local image:
```bash
python3 sample.py image.jpg
```


## About API keys

This demo by default sends requests to free endpoint at `demo.api4ai.cloud`.
Demo endpoint is rate limited and should not be used in real projects.

Use [RapidAPI marketplace](https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details) to get the API key. The marketplace offers both
free and paid subscriptions.

[Contact us](https://api4.ai/contacts) in case of any questions or to request a custom pricing plan
that better meets your business requirements.


## Links

📩 Email: hello@api4.ai
🔗 Website: https://api4.ai
🤖 Telegram demo bot: http://t.me/a4a_brand_det_bot
🔵 Our API at RapidAPI marketplace: https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
