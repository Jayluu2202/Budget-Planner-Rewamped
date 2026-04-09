# 💰 BudgetPlannerTUF

A modern, fintech-style **Finance Manager & Expense Tracker** built entirely in **SwiftUI**. Track income, expenses, and budgets with a beautiful gradient-based UI, smooth animations, and local-first storage.

## ✨ Features

- **Income & Expense Tracking** — Add transactions with amount, category, account, date, and notes. Full form validation ensures clean data entry.
- **Multiple Account Support** — Add and manage bank accounts (with account number, IFSC, UPI ID). Each transaction is linked to an account.
- **Custom Categories** — Predefined categories with SF Symbol icons and colors. Add your own custom categories from Settings.
- **Monthly Summary & Reports** — Donut chart with animated category breakdown, monthly income vs. expense stats, and per-category progress bars.
- **Dark & Light Mode** — Full theme support with a system/dark/light toggle. Gradient-based UI adapts beautifully across both modes.
- **Custom Tab Bar** — A curved tab bar with a floating action button (FAB) for quick "Add Transaction" access.
- **Animations Throughout** — Screen crossfades, staggered list animations, spring-based micro-interactions, press-down button effects, and shimmer loading states.
- **Local Storage** — All data persisted locally using `UserDefaults + Codable`. No backend required.
- **Multi-Currency Support** — Choose your preferred currency (INR, USD, EUR, GBP, etc.) from Settings.
- **Haptic Feedback** — Subtle haptic responses on interactions for a tactile feel.

---

## 📱 Screenshots
<img width="425" height="921" alt="Image" src="https://github.com/user-attachments/assets/d128b28b-3f94-4882-aa6a-ac1f2afd5974" />

<img width="428" height="929" alt="Image" src="https://github.com/user-attachments/assets/a9678f66-5271-464a-8df7-abff755c6e4f" />

<img width="421" height="922" alt="Image" src="https://github.com/user-attachments/assets/c3834094-1f6c-4bbd-b547-15988b4b8a0b" />

<img width="428" height="946" alt="Image" src="https://github.com/user-attachments/assets/8f2885e5-6ad1-4b39-a0f2-837ced5e7e78" />

<img width="408" height="920" alt="Image" src="https://github.com/user-attachments/assets/6195ee4e-2c61-43c3-b52f-6efe2ffdfe28" />

<img width="428" height="938" alt="Image" src="https://github.com/user-attachments/assets/f56ba004-da26-4705-8c53-e971ff615ad5" />

<img width="420" height="922" alt="Image" src="https://github.com/user-attachments/assets/33168123-ef26-47d2-8aaf-b0b6c4152b14" />

## 🎥 Demo Video



## 🏗️ Architecture & Project Structure

```
BudgetPlannerTUF/
├── App/
│   └── BudgetPlannerTUFApp.swift      # @main entry point
├── Models/
│   ├── Transaction.swift              # Transaction model (Codable, Identifiable)
│   ├── Category.swift                 # Category model with icon & color
│   ├── Account.swift                  # Bank account model
│   └── Enums.swift                    # TransactionType, Tab, AppTheme, CurrencyOption
├── ViewModels/
│   └── BudgetViewModel.swift          # Central ObservableObject — all business logic
├── Views/
│   ├── MainTabView.swift              # Root view with custom tab bar
│   ├── HomeView.swift                 # Balance card, account cards, recent transactions
│   ├── ExpenseView.swift              # Full transaction list with filters
│   ├── ReportView.swift               # Monthly summary, donut chart, category breakdown
│   ├── SettingsView.swift             # Theme, currency, accounts, categories management
│   ├── AddExpenseView.swift           # Add/edit transaction form
│   ├── ManageAccountsView.swift       # CRUD for bank accounts
│   └── ManageCategoriesView.swift     # CRUD for custom categories
├── Components/
│   ├── TabBarView.swift               # Custom curved tab bar + FAB
│   ├── TransactionRow.swift           # Expandable transaction row component
│   └── DonutChartView.swift           # Animated donut/pie chart
├── Theme/
│   └── ColorExtensions.swift          # Custom color definitions, gradients
└── Assets.xcassets/                   # App icons, accent colors, color sets
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI Framework** | SwiftUI (iOS 17+) |
| **State Management** | `@StateObject`, `@EnvironmentObject`, `@AppStorage` |
| **Storage** | `UserDefaults` + `Codable` (local-only, no backend) |
| **Charts** | Custom SwiftUI `Canvas` / `Path` donut chart |
| **Animations** | Spring animations, matched geometry, transitions |
| **Icons** | SF Symbols |
| **Haptics** | `UIImpactFeedbackGenerator` |

---

## 🚀 Getting Started

### Prerequisites
- **Xcode 15+** (with Swift 5.9+)
- **iOS 17.0+** deployment target
- No third-party dependencies — pure SwiftUI

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/BudgetPlannerTUF.git
   ```
2. Open `BudgetPlannerTUF.xcodeproj` in Xcode.
3. Select a simulator or connected device (iPhone 14 Pro or newer recommended).
4. Press `Cmd + R` to build and run.

> **Note:** No CocoaPods, SPM packages, or API keys required. The app runs entirely offline.

---

## 🎨 Design Highlights

- **Aurora Gradient Backgrounds** — Mesh-style gradients that shift between purple, indigo, and deep blue tones across all screens.
- **Glassmorphic Cards** — Frosted glass effect on balance and account cards using `.ultraThinMaterial` and gradient overlays.
- **Duolingo-Style Press Effect** — Buttons use a 3D press-down animation with offset and spring physics.
- **Staggered List Animations** — Transaction rows and settings sections animate in sequentially on appear.
- **Custom Curved Tab Bar** — Bezier-path cutout for the center FAB, not a stock `TabView`.

---

## 🙏 Acknowledgments

- [SF Symbols](https://developer.apple.com/sf-symbols/) by Apple
- Design inspiration from modern fintech apps (CRED, Wallet, Spendee)
