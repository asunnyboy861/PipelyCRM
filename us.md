# Pipely CRM - iOS Development Guide

## Executive Summary

Pipely is a simple, native iOS CRM designed for 3-5 person small teams - freelancers, small agencies, and startup sales teams. Unlike enterprise CRMs (Salesforce, HubSpot) that are overkill for small teams, Pipely focuses on the three things small teams actually need: Contacts, Pipeline, and Follow-ups. 

**Product Vision**: The simplest CRM that actually works on your phone. Zero learning curve, native iOS experience, and a price that makes sense for small teams ($9.99/month for the whole team, not per user).

**Key Differentiators**:
- Native iOS experience (not a wrapped web app) - solves mobile UX pain point
- Flat pricing for whole team ($9.99/mo vs $70-125/mo for competitors) - solves pricing pain point
- Zero learning curve (5 seconds to understand) - solves complexity pain point
- Free tier with real value (50 contacts, 1 pipeline, 20 deals) - lets users experience core value before upgrading

**Target Audience**: US market, 3-5 person teams, monthly CRM budget $10-30

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| HubSpot CRM | Free tier, brand recognition, integrations | Overkill for small teams, $15/user/mo paid, steep learning curve | Simpler, flat pricing, native iOS |
| Pipedrive | Best Kanban UX, strong pipeline focus | No free tier, $14/user/mo, web-first mobile | Free tier, native iOS, cheaper |
| Less Annoying CRM | Simple, small-team focused | $15/user/mo, no free tier, dated UI | Modern native UI, free tier, flat pricing |
| Capsule CRM | Clean design, good contact mgmt | Limited pipeline, $15/user/mo | Kanban pipeline, flat pricing |
| OnePageCRM | Action-based selling, 4.8 rating | $15/user/mo, no Kanban view | Kanban pipeline, free tier, cheaper |
| Zoho Bigin | Affordable at $9/user/mo, simple | Still per-user pricing, web-first | Flat pricing, native iOS |

## Apple Design Guidelines Compliance

- **HIG - Navigation**: Tab bar with 3 primary tabs (Pipeline, Contacts, Today) following Apple's recommendation of 3-5 tabs
- **HIG - Modality**: Sheet presentations for forms, full-screen for detail views
- **HIG - Haptics**: Haptic feedback on drag-and-drop deal movement
- **HIG - Dark Mode**: Full dark mode support with semantic colors
- **HIG - Accessibility**: Dynamic Type support, VoiceOver labels on all interactive elements
- **App Store Review - Business Apps**: No health/medical data, no kids category, standard business app
- **App Store Review - Subscriptions**: Must include auto-renewal terms, cancellation instructions, and restore purchases
- **App Store Review - Privacy**: Must disclose data collection in privacy policy and App Store Connect

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (drag-and-drop if needed)
- **Data**: SwiftData (iOS 17+ local persistence)
- **Cloud Sync**: CloudKit (free tier, no server cost)
- **Notifications**: UserNotifications framework (local push for follow-up reminders)
- **IAP**: StoreKit 2 (subscription management)
- **Contacts**: Contacts framework (import from device)
- **Email**: MFMailComposeViewController (system mail compose)
- **Minimum iOS**: 17.0

## Module Structure

```
Pipely CRM/
├── Pipely_CRMApp.swift
├── Models/
│   ├── Contact.swift
│   ├── Deal.swift
│   ├── DealStage.swift
│   ├── Activity.swift
│   └── FollowUp.swift
├── ViewModels/
│   ├── ContactsViewModel.swift
│   ├── PipelineViewModel.swift
│   ├── FollowUpViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Pipeline/
│   │   ├── PipelineView.swift
│   │   ├── PipelineColumnView.swift
│   │   ├── DealCardView.swift
│   │   ├── DealDetailView.swift
│   │   └── DealFormView.swift
│   ├── Contacts/
│   │   ├── ContactsListView.swift
│   │   ├── ContactDetailView.swift
│   │   └── ContactFormView.swift
│   ├── FollowUps/
│   │   ├── TodayView.swift
│   │   └── FollowUpRowView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── PaywallView.swift
│   │   └── ContactSupportView.swift
│   └── Components/
│       ├── SearchBar.swift
│       └── EmptyStateView.swift
├── Services/
│   ├── PurchaseManager.swift
│   ├── NotificationService.swift
│   └── EmailService.swift
└── Extensions/
    ├── Color+Theme.swift
    └── Date+Extensions.swift
```

## Implementation Flow

1. Create SwiftData models (Contact, Deal, DealStage, Activity, FollowUp)
2. Build Pipely_CRMApp with TabView and SwiftData container
3. Implement Pipeline Kanban view (horizontal scroll with columns)
4. Implement Deal CRUD (create, read, update, delete with forms)
5. Implement Contacts list with search and CRUD
6. Implement Today follow-up view with overdue/today/upcoming sections
7. Implement Activity tracking on Deal detail
8. Implement NotificationService for follow-up reminders
9. Implement PurchaseManager with StoreKit 2
10. Implement PaywallView for Pro upgrade
11. Implement SettingsView with policy links and support
12. Implement ContactSupportView with feedback backend
13. Configure app icon and capabilities
14. Test on iPhone and iPad simulators
15. Push to GitHub and deploy policy pages

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: Blue (#2563EB light / #3B82F6 dark)
  - Secondary: Violet (#7C3AED light / #8B5CF6 dark)
  - Success: Green (#16A34A / #22C55E)
  - Warning: Amber (#D97706 / #F59E0B)
  - Danger: Red (#DC2626 / #EF4444)
  - Background: White (#FFFFFF) / Slate 900 (#0F172A)
  - Surface: Slate 50 (#F8FAFC) / Slate 800 (#1E293B)

- **Typography**: SF Pro system font, Dynamic Type support
  - Large Title: 34pt bold (deal value, section headers)
  - Title 2: 22pt (deal titles, contact names)
  - Body: 17pt regular (descriptions, notes)
  - Caption: 12pt (dates, secondary info)

- **Layout**:
  - Tab bar: 3 tabs (Pipeline, Contacts, Today)
  - Pipeline: Horizontal scrolling Kanban columns
  - Cards: Rounded corners (12pt), subtle shadow
  - iPad: Max width 720pt for content, centered layout
  - Safe area insets respected on all devices

- **Animations**:
  - Deal card drag: Spring animation with haptic feedback
  - Tab transitions: Default SwiftUI transition
  - Sheet presentations: Medium detent for forms, large for detail
  - List row insert/delete: Default SwiftUI animation

- **Pipeline Stage Colors**:
  - Lead: Slate 400 (#94A3B8)
  - Qualified: Blue 400 (#60A5FA)
  - Proposal: Amber 400 (#FBBF24)
  - Negotiation: Orange 400 (#FB923C)
  - Won: Emerald 400 (#34D399)
  - Lost: Red 400 (#F87171)

## Code Generation Rules

- One feature per module, MVVM pattern
- SwiftData @Model for all data models
- All model attributes must be optional or have default values
- All relationships must have inverse relationships
- No code comments unless explicitly requested
- Use semantic color names from Color+Theme extension
- iPad layout: .frame(maxWidth: 720).frame(maxWidth: .infinity) for main content
- Never use .tabViewStyle(.sidebarAdaptable)
- StoreKit 2 for all IAP operations
- Native Apple frameworks first (no third-party dependencies)

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.PipelyCRM
2. Verify Deployment Target: iOS 17.0
3. Verify Swift Language Version: 5.0+
4. Configure App Icon (1024x1024)
5. Enable Push Notifications capability
6. Build on iPhone simulator (iPhone XS Max)
7. Build on iPad simulator (iPad Pro 13-inch M4)
8. Create GitHub repository
9. Push source code
10. Deploy policy pages to GitHub Pages
11. Generate App Store screenshots
12. Write App Store metadata (keytext.md)
