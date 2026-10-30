# AuraWelth Pro

AuraWelth Pro is a local-first Flutter finance tracker for Android. It keeps
the existing `com.example.installment_tracker` application ID so existing
installations and saved payment plans can be upgraded without changing app
identity. The app starts without third-party Flutter plugins; structured data
is stored on-device through the Android preferences bridge.

## Features

- Salary amount, pay day, available balance, and a finance ledger for salaries,
  expenses, payments, adjustments, and insufficient-balance alerts.
- Installment tracking for Tabby, Tamara, BIRD, SNB FLEX, and custom providers.
  Tabby and Tamara plans support selectable terms from 2 to 24 months.
  SNB FLEX plans are fixed to four months; BIRD and custom plans allow their
  entered terms.
- Car and device installments, with devices optionally linked to a service
  contract.
- Mobile, internet, insurance, and other service contracts, including bundled
  device charges and contract renewal dates.
- Vehicle service requests, status tracking, fees, notes, and reminder dates.
- Category budgets with month-to-date spending and overspend indicators.
- Finance analysis charts for six-month income, expenses, and installment
  payments, plus current-month budget-versus-spending totals by category.
- Multiple savings accounts with deposits, withdrawals, account-to-account
  transfers, per-account transaction history, and one-time opening balances for
  savings accumulated before using the app. Opening balances do not reduce
  salary cash; new deposits do.
- A 24-karat gold vault that converts the live XAU spot quote into SAR per gram,
  refreshes while the app is foregrounded, and supports manual refresh and
  manual price entry. Gold purchases and sales update the finance ledger and
  holdings; trade history is retained locally.
- Independently editable start and expiration dates for installment plans,
  device installments, and car loans. Older plans derive an expiration date
  from their existing start date and term when possible.
- Existing installment plans are tracked using their current unpaid balance
  and remaining term. Set the next payment date to the next unpaid installment;
  past paid installments are not entered as new expenses.
- English and Arabic interface direction, light/dark/system themes, and
  configurable Android payment and renewal notifications.

Payment and contract reminders are scheduled for 9:00 AM Riyadh time. Android
may ask for notification permission. Reminder schedules are restored after a
device restart. Automatic payment reconciliation records a due payment only
when the available ledger balance can cover it; otherwise it records a
shortfall and moves the next due date forward by one month.

The app also reads the original `payment_plans` storage key when migrating an
older installation. That legacy value is retained after migration; malformed
saved data is reported rather than silently replaced.

Gold spot-price refresh requires internet access. Savings transfers change only
the savings-account balances and are excluded from income and expense charts.

## Run and verify

Install Flutter and the Android SDK, then run:

```powershell
flutter pub get
flutter run
flutter analyze
flutter test
flutter build apk --release
```

The release APK is written to
`build/app/outputs/flutter-apk/app-release.apk`.
