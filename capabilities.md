# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "通知" / "提醒" / "alert" → Push Notifications (follow-up reminders)
- "同步" / "sync" / "iCloud" → iCloud capability (CloudKit sync)
- "购买" / "订阅" / "会员" / "premium" → In-App Purchase (subscription)
- "通讯录" / "导入" → Contacts framework (import contacts)
- "邮件" / "email" → No special capability needed (MFMailComposeViewController)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project |
| In-App Purchase | ✅ Configured | StoreKit 2 |
| Contacts | ✅ Configured | Info.plist key |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud / CloudKit | ⏳ Pending | 1. Open Xcode → Signing & Capabilities → + Capability → iCloud 2. Check CloudKit 3. Create container: iCloud.com.zzoutuo.PipelyCRM 4. Create CloudKit schema in CloudKit Dashboard |

## No Configuration Needed
- Camera / Photo Library — not needed
- Location Services — not needed
- HealthKit — not needed
- Apple Watch — not needed
- Siri — not needed
- Background Modes — local notifications handle follow-up reminders without background modes

## Verification
- Build succeeded after configuration: ✅
- All entitlements correct: ✅
- iCloud / CloudKit: ⏳ Manual setup required in Xcode before App Store submission
