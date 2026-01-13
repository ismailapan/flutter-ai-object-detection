# 🍎 Sanal Diyetisyen - AI Destekli Nesne Tespiti

Bu proje, yapay zeka destekli görüntü işleme tekniklerini kullanarak meyve ve sebzeleri tanıyan ve kullanıcılara besin değerleri hakkında bilgi veren full-stack bir mobil uygulamadır.

## 🚀 Proje Hakkında

Kullanıcılar, mobil uygulama üzerinden kamerayı kullanarak veya galeriye yükleyerek bir yiyeceğin fotoğrafını çeker. Python tabanlı YOLO modeli nesneyi tespit eder, Node.js backend servisi gerekli verileri işler ve Flutter arayüzünde kullanıcıya sonuçları sunar.

### 🌟 Temel Özellikler
* **Gerçek Zamanlı Nesne Tespiti:** YOLO mimarisi ile eğitilmiş model sayesinde yüksek doğrulukta meyve/sebze tanıma.
* **Kullanıcı Dostu Arayüz:** Flutter ile geliştirilmiş modern ve akıcı mobil deneyim.
* **API Entegrasyonu:** Node.js ile güçlendirilmiş güvenli backend mimarisi.
* **Veri Analizi:** Tespit edilen nesnelerin besin değerlerinin sunulması.

---

## 🛠️ Kullanılan Teknolojiler (Tech Stack)

Proje 3 ana katmandan oluşmaktadır:

| Alan | Teknoloji | Açıklama |
|---|---|---|
| **Mobile (Frontend)** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) | Kullanıcı arayüzü ve kamera işlemleri. |
| **Backend (API)** | ![NodeJS](https://img.shields.io/badge/Node.js-43853D?style=flat&logo=node.js&logoColor=white) | Veri akışı ve API yönetimi. |
| **AI / Model** | ![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white) | YOLOv8/11 ile model eğitimi ve görüntü işleme. |
| **Veritabanı** | ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) | (Kullandıysan burayı güncelle) Kullanıcı verileri. |

---

## 📂 Proje Yapısı

```text
📦 Sanal-Diyetisyen-Projesi
 ┣ 📂 mobile/       # Flutter mobil uygulama kodları
 ┣ 📂 backend/      # Node.js API ve servis kodları
 ┣ 📂 ai-model/     # Python model eğitimi, dataset notları ve .pt dosyaları
 ┗ 📜 README.md     # Proje dokümantasyonu
