# Analisis Sentimen Kampus — Panduan Setup

Proyek: FastAPI (backend) + Streamlit (frontend web) + Flutter (frontend mobile),
dijalankan via Docker Compose, lalu di-deploy ke cloud.

## 0. Prasyarat
- Docker Desktop (WSL2 backend aktif)
- Python 3.12 (opsional, untuk run lokal tanpa Docker)
- Flutter SDK + Android Studio (untuk bagian mobile)

## 1. Taruh model Anda
Copy file `sentiment.pkl` Anda ke:
    backend/models/sentiment.pkl
(hapus file placeholder `TARUH_sentiment.pkl_DI_SINI.txt` di folder yang sama)

`model_service.py` mengasumsikan `sentiment.pkl` adalah sklearn Pipeline
(TF-IDF + classifier) yang bisa menerima teks mentah langsung lewat
`model.predict([text])` dan `model.predict_proba([text])`.
Jika struktur model Anda berbeda (misal vectorizer & classifier disimpan
terpisah, atau label berupa angka bukan string), sesuaikan
`backend/app/model_service.py`.

## 2. Jalankan dengan Docker Compose
Dari folder root proyek ini:

    docker compose up -d
    docker compose ps

Pastikan `analisis-sentimen-api` dan `analisis-sentimen-web` berstatus Up.

Cek backend:

    curl http://localhost:8000/health

Buka frontend web: http://localhost:8501

## 3. Setup Flutter (opsional, untuk versi mobile)
Dari folder root proyek ini:

    flutter create frontend
    cd frontend
    flutter pub add http

Lalu timpa isi `frontend/lib/main.dart` dengan isi dari
`flutter_reference/lib/main.dart`, dan `frontend/test/widget_test.dart`
dengan isi dari `flutter_reference/test/widget_test.dart`.

Jalankan:

    flutter test
    flutter run

Saat test di emulator Android, isi field "URL API" di aplikasi dengan
`http://10.0.2.2:8000` (bukan `localhost`), karena emulator mengakses
komputer host lewat alamat khusus tersebut.

## 4. Deploy backend ke Hugging Face Docker Space
1. Buat Space baru di huggingface.co, SDK: Docker.
2. Metadata sudah disiapkan di `backend/README.md` (title, sdk: docker, app_port: 8000).
3. Push isi folder `backend/` ke repo Space tersebut (git init, remote, push).
4. Tunggu build selesai di tab Logs, lalu tes:
       curl https://<space-url>/health
       buka https://<space-url>/docs

## 5. Hubungkan frontend ke URL cloud
- Streamlit (`app.py`): ganti default `api_url` ke `https://<space-url>`.
- Flutter (`main.dart`): ganti isi field "URL API" ke `https://<space-url>`,
  atau ubah default `apiUrlController` di kode.

## 6. Build Flutter web (opsional)
    cd frontend
    flutter build web
