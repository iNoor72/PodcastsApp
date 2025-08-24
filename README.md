# PodcastApp

A modular iOS podcast application built with SwiftUI and Swift Package Manager, following clean architecture principles.

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

## Architecture

This project uses a modular architecture with separate Swift packages for different concerns:

### Modules

- **Common** - Shared utilities, UI components, navigation, and font management
- **Domain** - Business logic, models, use cases, and repository interfaces
- **Data** - Data layer implementation, repositories, and API responses
- **DI** - Dependency injection container and app coordination
- **Presentation** - Feature modules (HomeScreen, SearchScreen)

### Design Patterns

- **MVVM** - Model-View-ViewModel for presentation layer
- **Repository Pattern** - Data access abstraction
- **Use Cases** - Business logic encapsulation
- **Coordinator Pattern** - Navigation management
- **Dependency Injection** - Loose coupling between modules


## 📱 PodcastApp Project Structure

This project follows a modular architecture using Swift Package Manager for clean separation of concerns.

### 🏗️ Architecture Overview

```
PodcastApp/
├── 📱 PodcastApp/                       # Main Application Target
│   ├── Info.plist                      # App configuration & metadata
│   ├── PodcastApp.swift                 # Application entry point
│   └── Modules/                         # Modular Swift Packages
```

## 📦 Core Modules

### 🔧 Common Module
**Shared utilities and reusable components**
```
Common/
├── Package.swift
└── Sources/Common/
    ├── Constants/                       # App-wide constants
    ├── Extensions/                      # Swift language extensions
    ├── Fonts/                          # Typography management
    ├── Navigation/                     # Navigation coordination
    └── UI/                             # Reusable UI components
        ├── SwiftUI/                    # SwiftUI-based components
        └── UIKit/                      # UIKit-based components
```

### 💉 Dependency Injection (DI)
**Manages object creation and dependencies**
```
DI/
└── Sources/DI/
    ├── Coordinators/                   # Application flow coordination
    ├── Factories/                      # Screen & component factories
    └── Protocols/                      # Dependency injection contracts
```

### 💾 Data Layer
**Handles data persistence and API communication**
```
Data/
└── Sources/Data/
    ├── Helpers/                        # Data transformation utilities
    ├── Repositories/                   # Data repository implementations
    └── Responses/                      # API response models
```

### 🏢 Domain Layer
**Contains business logic and domain models**
```
Domain/
├── Sources/Domain/
│   ├── Endpoints/                      # API endpoint definitions
│   ├── Helpers/                        # Domain-specific utilities
│   ├── Models/                         # Core business models
│   ├── Repository Interfaces/          # Repository contracts
│   └── UseCases/                       # Business logic operations
└── Tests/DomainTests/                  # Domain layer unit tests
```

### 🎨 Presentation Layer
**Feature-based UI modules**
```
Presentation/
├── HomeScreen/                         # Home feature module
└── SearchScreen/                       # Search feature module
```

## 🏛️ Architecture Benefits

- **🔄 Clean Architecture**: Clear separation between data, domain, and presentation layers
- **📦 Modular Design**: Independent Swift packages for better maintainability
- **🧪 Testable**: Domain logic isolated for easy unit testing
- **♻️ Reusable**: Common components shared across features
- **🔀 Scalable**: Easy to add new features as separate modules

## 🚀 Getting Started

1. Open `PodcastApp.xcodeproj` in Xcode
2. Build the project - Swift Package Manager will resolve all dependencies
3. Run the app on your preferred simulator or device

---

*This modular structure ensures maintainable, testable, and scalable iOS development.*


## Features

### Core Features
- 🏠 **Home Screen** - Browse podcast sections and featured content
- 🔍 **Search** - Search for podcasts and episodes

### Technical Features
- 📦 **Modular Architecture** - Separated concerns with Swift packages
- 🧪 **Unit Testing** - Comprehensive test coverage for domain layer
- 🔄 **Async/Await** - Modern Swift concurrency
- 📱 **SwiftUI** - Declarative UI framework
- 🎯 **Type Safety** - Strongly typed API layer


### Features
- ✅ Centralized font registration
- ✅ Type-safe font usage with enums
- ✅ SwiftUI and UIKit compatibility
- ✅ Dynamic type support
- ✅ Font verification and debugging
