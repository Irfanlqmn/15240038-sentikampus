---
title: Analisis Sentimen API
sdk: docker
app_port: 8000
---

Backend FastAPI untuk analisis sentimen (deploy sebagai Hugging Face Docker Space).

Endpoints:
- GET /health
- GET /docs
- POST /api/v1/predict  body: {"text": "..."}
