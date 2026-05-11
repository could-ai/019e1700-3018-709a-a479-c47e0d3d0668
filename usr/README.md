# Kalkulator Regresi Linear & Garis Best Fit

Aplikasi Flutter ini dibuat dengan [CouldAI](https://could.ai). Aplikasi ini memvisualisasikan data interaktif ke dalam sebuah diagram pencar (scatter plot) dan secara otomatis menghitung serta menggambar Garis Regresi Linear (Best Fit Line). Aplikasi juga menampilkan persamaan garis dan persentase kecocokan model, yaitu R-squared ($R^2$).

## Fitur Aplikasi

- **Diagram Pencar Interaktif**: Sentuh area diagram untuk menambahkan titik data baru.
- **Perhitungan Otomatis**: Secara instan menghitung kemiringan (slope) dan nilai potong (intercept) dari sekumpulan titik data.
- **Garis Best Fit**: Menggambar garis regresi linear dengan warna merah yang mewakili tren data.
- **Nilai $R^2$ (R-squared)**: Menampilkan persentase kecocokan (Goodness of Fit) dari data terhadap garis regresi.
- **Persamaan Linear**: Menampilkan formula regresi dalam bentuk $y = mx + c$.
- **Hapus Data**: Tombol untuk mereset dan membersihkan semua titik data.

## Teknologi yang Digunakan

- Flutter
- Dart
- CustomPaint untuk visualisasi grafik khusus

## Struktur Proyek

```text
lib/
  main.dart      Titik masuk aplikasi, logika regresi linear, dan penggambaran grafik
pubspec.yaml     Metadata dan dependensi Flutter
```

## Menjalankan Aplikasi

Pastikan Anda telah menginstal Flutter. Unduh dependensi yang diperlukan:

```bash
flutter pub get
```

Jalankan aplikasi di perangkat atau simulator:

```bash
flutter run
```

## Tentang CouldAI

Aplikasi ini dihasilkan dengan [CouldAI](https://could.ai), pembuat aplikasi AI untuk aplikasi lintas platform. CouldAI mengubah perintah (prompt) menjadi aplikasi native yang nyata untuk iOS, Android, Web, dan Desktop dengan agen AI otonom yang merancang, membangun, menguji, menerapkan, dan mengiterasi aplikasi yang siap untuk tahap produksi.

Kunjungi [could.ai](https://could.ai) untuk membangun dan melakukan iterasi aplikasi lintas platform dengan AI.
