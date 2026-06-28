# 🧾 FisMatik - iOS Fiş Tarayıcı ve Excel Aktarıcı

FisMatik, elinizdeki alışveriş fişlerini iPhone kamerasıyla tarayarak **Firma Adı**, **Toplam Tutar** ve **KDV** bilgilerini otomatik olarak ayıklayan ve doğrudan Excel'e yapıştırılabilir/aktarılabilir formatta sunan, yerel (native) bir iOS mobil uygulamasıdır (MVP).

Uygulama, tamamen cihaz üzerinde çalışır; internet bağlantısına veya ücretli harici API'lere (Google Cloud Vision vb.) ihtiyaç duymaz.

---

## ✨ Özellikler

* **📸 Ardışık (Toplu) Tarama**: Kamera açıldığında "Keep Scanning" seçeneğiyle arka arkaya birden fazla fiş tarayabilir ve tek tıkla kaydedebilirsiniz.
* **🧠 Yerel Akıllı OCR (Apple Vision)**: Cihaz içi metin tanıma motoru sayesinde Türkçe karakter desteğiyle fiş metinlerini saniyeler içinde okur.
* **🔬 Gelişmiş Metin Ayrıştırma Algoritması**:
  * **Sütun Kayması Desteği**: OCR'ın etiketleri (topkdv, toplam) ve değerleri (*96,09, *1.057,00) ayrı satırlar halinde okuduğu durumlarda akıllı `isClaimed` (sahiplenme) ve `lookahead` (ileri bakış) algoritmalarıyla doğru fiyatı doğru etiketle eşleştirir.
  * **Gürültü Filtreleme**: Kredi kartı maskeli numaralarını (`**** 5811`), Z raporu numaralarını (`Z No: 0333`), fiş numaralarını, tarihleri, saatleri ve yılları otomatik olarak ayıklar ve fiyat olarak algılamaz.
  * **KDV Koruma Limiti**: KDV'nin toplam tutarın %22'sinden büyük olamayacağı kuralını uygulayarak matrah ve ürün fiyatlarının yanlışlıkla KDV olarak seçilmesini engeller.
* **📊 Excel Uyumlu CSV Paylaşımı**: 
  * Oluşturulan `.csv` dosyası, Türkçe Excel uyumluluğu için **noktalı virgül (`;`)** ayırıcılıdır.
  * Türkçe karakterlerin Excel'de bozulmadan görünmesi için **UTF-8 BOM (`\u{FEFF}`)** bayt işareti eklenmiştir.
* **📋 Ortak Pano (Universal Clipboard) Desteği**: "Panoya Kopyala" butonuyla kopyaladığınız verileri, Mac bilgisayarınızın başına geçip doğrudan Excel'e **Cmd+V** ile yapıştırabilirsiniz.
* **✏️ Listeden Düzenleme (Tap-to-Edit)**: Taranan tüm fişler doğrudan listeye eklenir; hatalı okunan bir fişin üzerine tıklayarak bilgileri elle düzeltebilirsiniz.
* **⚠️ Temizlik Güvenliği**: Listeyi temizle butonuna basıldığında kazara veri kayıplarını önlemek için onay uyarısı (Alert) gösterilir.
* **💾 Yerel Depolama**: Taranan veriler `UserDefaults` kullanılarak cihazda güvenle saklanır, uygulama kapatılsa bile kaybolmaz.

---

## 🛠️ Nasıl Çalıştırılır?

### Gereksinimler
* macOS işletim sistemi
* Xcode 14.0 veya üzeri
* Ücretsiz bir Apple Geliştirici (Developer) Hesabı

### Kurulum Adımları
1. Bu depoyu klonlayın veya zip olarak indirin.
2. Klasör içindeki **`ReceiptScanner.xcodeproj`** dosyasına çift tıklayarak projeyi Xcode'da açın.
3. Apple ID'nizi Xcode'a bağlayıp **Signing & Capabilities** sekmesinden kendi Team'inizi seçin (ücretsiz kişisel hesap yeterlidir).
4. iPhone'unuzu bilgisayarınıza bağlayın, cihaz listesinden telefonunuzu seçip sol üstteki **Run (Oynat)** butonuna basın.

---

## 📂 Proje Yapısı

* `ReceiptScannerApp.swift`: Uygulama başlangıç noktası.
* `ContentView.swift`: Fişlerin listelendiği, toplu tarama sonuçlarının eklendiği ve Excel paylaşım fonksiyonlarının yönetildiği ana ekran.
* `ScannerView.swift`: Apple `VisionKit` ve `Vision` kütüphanelerini SwiftUI'a bağlayan kamera ve OCR katmanı.
* `ResultEditView.swift`: Listeden seçilen veya yeni taranan fiş verilerinin düzenlendiği onay ekranı.
* `ReceiptParser.swift`: Ham OCR metnini analiz eden ve fiyatları/KDV'leri ayıklayan regex motoru.
* `ReceiptModel.swift`: Fiş veri modelini ve Excel TSV formatlama kodlarını barındıran yapı.
* `generate_project.py`: Xcode proje yapısını oluşturan kurulum betiği.

---

## 📝 Lisans

Bu proje kişisel kullanım amacıyla geliştirilmiş bir MVP'dir. İstediğiniz gibi genişletebilir ve geliştirebilirsiniz.
