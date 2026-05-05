# Git Repositories

## Main App (iOS Application + Policy Pages)

| Item | Value |
|------|-------|
| **Repository Name** | PipelyCRM |
| **Git URL** | git@github.com:asunnyboy861/PipelyCRM.git |
| **Repo URL** | https://github.com/asunnyboy861/PipelyCRM |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Support | https://asunnyboy861.github.io/PipelyCRM/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/PipelyCRM/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/PipelyCRM/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

### Main App Repository
```
PipelyCRM/
├── Pipely CRM/                          # Xcode Project
│   ├── Pipely CRM.xcodeproj/            # Xcode Project File
│   ├── Pipely CRM/                      # Swift Source Files
│   │   ├── Pipely_CRMApp.swift          # App Entry Point
│   │   ├── ContentView.swift            # Main TabView
│   │   ├── Models/                      # SwiftData Models
│   │   │   ├── Contact.swift
│   │   │   ├── Deal.swift
│   │   │   ├── Activity.swift
│   │   │   └── FollowUp.swift
│   │   ├── Views/                       # SwiftUI Views
│   │   │   ├── Pipeline/               # Kanban Pipeline
│   │   │   ├── Contacts/               # Contact Management
│   │   │   ├── FollowUps/              # Today & Follow-ups
│   │   │   ├── Settings/               # Settings, Paywall, Support
│   │   │   └── Components/             # Shared UI Components
│   │   ├── Services/                    # Business Logic
│   │   │   ├── PurchaseManager.swift
│   │   │   ├── NotificationService.swift
│   │   │   └── EmailService.swift
│   │   └── Extensions/                  # Swift Extensions
│   │       ├── Color+Theme.swift
│   │       └── Date+Extensions.swift
│   └── Assets.xcassets/                 # App Icons & Assets
├── docs/                                # Policy Pages (GitHub Pages)
│   ├── support.html
│   ├── privacy.html
│   └── terms.html
├── .github/workflows/
│   └── deploy.yml                       # GitHub Pages Auto-Deploy
├── us.md                                # English Development Guide
├── keytext.md                           # App Store Metadata
├── capabilities.md                      # Capabilities Configuration
├── icon.md                              # App Icon Details
├── price.md                             # Pricing Configuration
└── nowgit.md                            # This File
```
