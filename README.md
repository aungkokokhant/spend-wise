# 💰 SpendWise

**SpendWise** is a modern personal finance mobile application built with Flutter to help users track their **income and expenses** with clarity, simplicity, and powerful insights.

Designed with a clean UI and smooth user experience, SpendWise enables users to manage their daily, weekly, and monthly finances effectively — all offline.

---

## 🚀 Features

### 📊 Dashboard

* Total Balance overview
* Income vs Expense summary
* Daily, Weekly, Monthly insights
* Beautiful interactive charts

### 💸 Transaction Management

* Add / Edit / Delete transactions
* Categorize income & expenses
* Date-based filtering (Daily / Weekly / Monthly)
* Search transactions بسهولة

### 📈 Analytics

* Category-based expense breakdown
* Weekly & monthly trends
* Visual charts using `fl_chart`

### 🌗 Theme Support

* Light Mode
* Dark Mode
* Persistent theme settings

### 🌍 Localization

* English 🇺🇸
* Myanmar 🇲🇲
* Easy language switching
* Fully localized UI

### 💾 Offline Storage

* Local data persistence using:

    * SharedPreferences
    * (Optional) Hive for structured data

### ⚙️ Settings

* Theme toggle
* Language selection
* Clear all data
* App information

---

## 🧱 Tech Stack

* **Flutter** (Latest Stable)
* **Riverpod** (State Management)
* **GoRouter** (Routing)
* **SharedPreferences / Hive** (Local Storage)
* **Intl (ARB)** (Localization)
* **Material 3 UI**
* **fl_chart** (Data Visualization)

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── theme/
│   ├── constants/
│   ├── utils/
│   ├── services/
│
├── features/
│   └── finance/
│       ├── data/
│       ├── models/
│       ├── providers/
│       ├── views/
│       ├── widgets/
│
├── l10n/
├── main.dart
```

---

## 🧠 Architecture

SpendWise follows a **Clean Architecture + Feature-first approach**:

* Scalable and maintainable codebase
* Separation of concerns
* Reusable components
* Optimized state updates with Riverpod

---

## 🎨 UI/UX Design

* Modern fintech-inspired interface
* Smooth animations and transitions
* Clean typography and spacing
* Responsive layout
* Minimal and elegant color system

---

## ⚙️ Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/aungkokokhant/spend-wise.git
cd spendwise
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

---

## 📦 Package Name

```
com.aungkokokhant.spendwise
```

---

## 🔮 Future Improvements

* Cloud sync (Firebase / Laravel API)
* Multi-device support
* Export to PDF / Excel
* Budget planning system
* Notifications & reminders
* AI-based spending insights

---

## 👨‍💻 Developer

**Aung Ko Ko Khant**
Senior Flutter & Backend Developer (Laravel, Node.js)

* Mobile Apps (Flutter)
* Backend Systems (PHP Laravel, MySQL, MongoDB)
* Real-time systems (Socket.io)
* Production-ready scalable apps

---

## 📜 License

This project is licensed under the MIT License.

---

## ⭐ Support

If you like this project:

* Star ⭐ the repo
* Share with others
* Contribute improvements

---

## 💡 Vision

SpendWise is built with the vision to become a **simple yet powerful personal finance assistant** for everyday users — starting offline, growing into a full financial ecosystem.

---
