# 📊 Flutter Web CSV Viewer with Pagination

This Flutter Web app allows users to upload a `.csv` file, view its content in a styled table, and navigate through the rows using paginated buttons (`Previous`, `Next`, and page numbers).

---

## ✨ Features

- ✅ Upload CSV files from your computer
- ✅ Parse and display CSV content in a responsive table
- ✅ Automatic pagination (10 rows per page)
- ✅ Navigation: page numbers, next/previous buttons
- ✅ Store file in browser's `localStorage`
- ✅ Clear/reset file via a delete button
- ✅ 100% Flutter Web-compatible (no server or backend needed)

---

## 🚀 Getting Started

### 1. Clone this repository
```bash
git clone https://github.com/your-username/flutter-web-csv-viewer.git
cd flutter-web-csv-viewer
```
###2. Install dependencies
```bash
Copy
Edit
flutter pub get
```

###3. Run for Web
```bash
Copy
Edit
flutter run -d chrome
```
📌 Make sure Flutter is correctly installed and Web is enabled:
flutter devices should show Chrome or Edge as available

🛠 Dependencies
```yaml
Copy
Edit
dependencies:
  flutter:
    sdk: flutter
  csv: ^5.1.0
```
No additional plugins needed — no path_provider, file_picker, or Firebase!

📁 File Structure
```bash
Copy
Edit
/lib
  └── main.dart         # Main application file
/web
  └── index.html        # Web entrypoint (auto-generated)
/README.md              # This file
/pubspec.yaml           # Project config and dependencies
```

📌 Notes
File content is stored in browser localStorage under key savedCSV

This app does not persist data across devices/browsers

The table is optimized for small to medium CSV files (<10k rows)

📦 Todo / Ideas
🔍 Add search/filter by column value

📤 Export table back to CSV

☁️ Optional Firebase/Cloud saving

🎨 Improved styling / mobile responsiveness

👨‍💻 Developed by
Shai Sasonker
📍 Built with Flutter Web 💙
