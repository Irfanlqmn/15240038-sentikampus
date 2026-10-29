from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .schemas import SentimentRequest, SentimentResponse
from .model_service import predict_text

app = FastAPI(title="Analisis Sentimen API Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "message": "Analisis Sentimen API berjalan",
        "docs": "/docs",
        "health": "/health",
    }


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/api/v1/predict", response_model=SentimentResponse)
def predict(data: SentimentRequest):
    result = predict_text(data.text)
    return SentimentResponse(**result)