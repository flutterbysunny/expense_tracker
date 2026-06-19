# 💰 Expense Tracker

A clean, offline-first expense tracking app built with **Flutter** and **BLoC** state management. Track your daily spending, categorize expenses, and visualize where your money goes — all stored locally on your device.

## ✨ Features

- ➕ **Add, edit, and delete expenses** with title, amount, category, and date
- 🗂️ **Category-based organization** (Food, Transport, Shopping, Bills, Entertainment, Health, Other)
- 🔍 **Filter expenses** by category with quick-select chips
- 📊 **Visual summary** with an interactive pie chart showing category-wise spending breakdown
- 💾 **100% offline** — all data persisted locally using Hive, no internet required
- 🎨 **Material 3 design** with a clean, modern UI
- 👆 **Swipe to delete** for quick expense management

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | flutter_bloc (BLoC pattern) |
| Local Database | Hive |
| Charts | fl_chart |
| Architecture | Feature-first, clean separation (data / bloc / view / widgets) |

## 📂 Project Structure

```
lib/
├── core/                  # Constants, theming, utilities
├── data/
│   ├── models/            # Hive data models
│   └── repositories/      # CRUD logic / data access layer
├── features/
│   ├── expense_list/      # Home screen: list, filter, delete (BLoC)
│   ├── add_expense/       # Add expense form
│   └── summary/           # Pie chart + category breakdown (BLoC)
└── widgets/                # Shared/reusable widgets
```

This follows a **feature-first architecture** where each feature is self-contained with its own `bloc/`, `view/`, and `widgets/` — making the codebase easy to navigate, test, and extend.

## 🏗️ Architecture Highlights

- **BLoC Pattern**: Clear separation between UI and business logic using Events → Bloc → States
- **Repository Pattern**: All data access goes through `ExpenseRepository`, decoupling the UI/Bloc layer from the storage implementation
- **Equatable**: Used for state/event comparison to avoid unnecessary widget rebuilds
- **Offline-first**: No backend dependency — Hive provides fast, lightweight local persistence

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or later)
- Dart SDK

### Installation

```bash
# Clone the repository
git clone https://github.com/flutterbysunny/expense_tracker.git
cd expense_tracker

# Install dependencies
flutter pub get

# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## 📸 Screenshots

| Home Screen | Add Expense | Summary |
|---|---|---|
| _screenshot here_ | _screenshot here_ | _screenshot here_ |

## 🔮 Possible Future Enhancements

- [ ] Monthly/weekly spending trends (line/bar charts)
- [ ] Budget limits with alerts
- [ ] Export data to CSV/PDF
- [ ] Dark mode toggle
- [ ] Cloud sync / backup

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

Built with ❤️ using Flutter & BLoC