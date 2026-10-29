import streamlit as st
import requests

st.set_page_config(page_title="Analisis Sentimen Kampus", page_icon="🎓")

st.title("🎓 Analisis Sentimen Kampus")
st.write("Masukkan komentar untuk menganalisis sentimen terhadap layanan kampus.")

api_url = st.text_input(
    "URL FastAPI",
    value="http://backend:8000",
    placeholder="http://backend:8000",
)

komentar = st.text_area("Komentar", max_chars=500)

if st.button("Analisis Sentimen"):
    if not komentar.strip():
        st.warning("Masukkan komentar terlebih dahulu.")
    else:
        try:
            response = requests.post(
                f"{api_url}/api/v1/predict",
                json={"text": komentar},
                timeout=10,
            )
            response.raise_for_status()
            hasil = response.json()

            st.subheader("Hasil Analisis")
            label = hasil["label"]
            if label.lower() == "positive":
                st.success(f"😊 {label.upper()}")
            elif label.lower() == "negative":
                st.error(f"😟 {label.upper()}")
            else:
                st.info(f"😐 {label.upper()}")
            st.caption(f"Skor model: {hasil['score']:.2%}")
        except Exception as e:
            st.error(f"Gagal menghubungi API: {e}")
