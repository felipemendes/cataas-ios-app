# CATAAS iOS App

## Table of Contents

- [Introduction](#introduction)
- [Architecture](#architecture)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)

## Introduction

CATAAS (Cat as a Service) is a SwiftUI-based iOS application that displays a list of cats fetched from an API. The app is built with a focus on clean architecture, MVVM (Model-View-ViewModel) pattern, and uses Combine for reactive programming. The goal of this app is to provide a scalable and maintainable codebase while demonstrating modern iOS development practices.

## Architecture

The app follows the Clean Architecture and MVVM (Model-View-ViewModel) design pattern with the Coordinator pattern for navigation. The project is structured into three main layers:

1. **Domain Layer**: Contains business logic and domain entities.
2. **Data Layer**: Handles data fetching from the network and any local data storage.
3. **Presentation Layer**: Contains the UI components and ViewModels.

### Domain Layer

- **Entities**: Defines the core data structures used throughout the app. In this case, `CatResponse` is the main entity representing a cat.
- **Repositories**: Responsible for data operations. `CatRepository` interacts with the `CatAPI` to fetch data.

### Data Layer

- **Networking**: Contains the business logic. Currently, the main use case is fetching the list of cats from the API.
- **API Services**: Handles network requests. `CatAPI` conforms to `CatAPIProtocol` and fetches data from the API.

### Presentation Layer

- **ViewModels**: Acts as the intermediary between the view and the data layer. `HomeViewModel` manages the state and logic for the `HomeView`.
- **Views**: SwiftUI views that represent the UI components. `HomeView` and `DetailView` are the main views.
- **Coordinators**: Manages navigation. `HomeCoordinator` handles the navigation logic for the home screen and detail view.

### Project Structure

```
├── CATAAS
│   ├── App
│   │   └── CATAASApp.swift
│   ├── Coordinators
|   |   |── AppCoordinator.swift
│   │   └── HomeCoordinator.swift
│   ├── Data
│   │   ├── Networking
│   │   │   ├── CatAPI.swift
│   │   │   ├── Endpoint.swift
│   │   │   └── NetworkingError.swift
│   │   └── Services
│   │       └── CatsService.swift
│   ├── Domain
│   │   ├── Models
│   │   │   └── CatResponse.swift
│   │   └── Repositories
│   │       ├── CatRepository.swift
│   │       └── CatServiceProtocol.swift
│   ├── Presentation
│   │   ├── Detail
│   │   │   ├── DetailView.swift
│   │   │   └── DetailViewModel.swift
│   │   └── Home
│   │       ├── HomeView.swift
│   │       └── HomeViewModel.swift
│   └── Shared
│       ├── AppConstants.swift
│       ├── Extensions
│       │   ├── AsyncImage+Cache.swift
│       │   └── Color+Extension.swift
│       ├── Helpers
│       │   ├── ImageLoader.swift
│       │   └── LocalFileManager.swift
│       └── Views
│           ├── CatCardView.swift
│           ├── CatImage.swift
│           └── TagsView.swift
```

## Features

- **Home View**: Displays a grid of cat images fetched from the API.
- **Detail View**: Shows detailed information about a selected cat, including its tags.
- **Pagination**: Fetches and displays cats in pages.
- **Image Caching**: Caches images for offline access.
- **Error Handling**: Displays error messages for network failures.
- **Loading Indicators**: Shows loading indicators during data fetching.

## Installation

To run the project locally, follow these steps:

1. Open the project in Xcode:
   ```bash
   cd CATAAS
   open CATAAS.xcodeproj
   ```

2. Build and run the project in Xcode.

## Usage

1. Launch the app on your simulator or device.
2. The home screen will display a list of cat images.
3. Tap on any cat image to navigate to the detail view, which shows more information about the selected cat.

## Testing

The project includes both unit tests and integration tests to ensure the app's functionality and reliability.
Tests are located in the `CATAAS/CATAASTests` directory. They cover the business logic, view models, and API interactions.

#### Running Unit Tests

1. Open the project in Xcode.
2. Select the `CATAAS` scheme.
3. Press `Cmd+U` to run all unit tests.
