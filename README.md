# OnboardingApp

This project is a **test assignment** for an iOS developer position.

It implements a small onboarding flow with multiple question screens and a paywall screen connected to **StoreKit 2** for subscription handling.

---

## 🧩 Features

- **Onboarding flow** with a sequence of question screens (`QuestionViewController`):
  - The number of screens with question automatically adapts to the items' count returned from the API response, making the flow flexible and scalable
- **Paywall screen** implemented using StoreKit 2:
  - Loads product details
  - Handles purchase
  - Uses `SubscriptionService` for subscription management
- **MVP architecture**
- **Async/await**
- **RxSwift** used for lightweight reactive bindings (e.g., button state, table selection)
- **SnapKit** for layout
- **UIKit-based project**, targeting iOS 16+

---

## 🧠 Notes & Improvements

There are several `// TODO:` comments across the project — they highlight potential areas for improvement and demonstrate awareness of scaling and architecture growth.
Because `I always want to improve, scale and make things better than they are now)`
