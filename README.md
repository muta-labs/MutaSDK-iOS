# <div align="center">Muta iOS SDK</div>

A Swift SDK for creating dynamic, remotely configurable onboarding experiences in your iOS app. Muta allows you to create, update, and A/B test your onboarding flows without deploying app updates or writing a single line of code.

## Features

- 🎨 No-code editor - design and update flows with a drag-and-drop interface
- 🚀 Remote updates - modify onboarding flows instantly without app releases
- ✨ Rich components - buttons, text, images, shapes, icons, and more
- 🔄 Smooth transitions - fade and slide animations
- 📊 Analytics integration - track user behavior with any analytics provider
- 📝 User input collection - gather text and multiple choice responses
- 💪 Full Swift support
- 🪶 Extremely lightweight

## Installation

### Swift Package Manager

Add the following dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/muta-labs/MutaSDK-iOS", from: "1.0.0")
]
```

Or in Xcode:
1. File > Add Packages
2. Enter package URL: `https://github.com/muta-labs/MutaSDK-iOS`
3. Click "Add Package"

## Quick Start

1. Initialize the SDK:

```swift
import MutaSDK

// In your app initialization
Muta.configure(apiKey: "your-api-key")
```

2. Display a placement:

```swift
// Basic usage
Muta.shared.displayPlacement(
    placementId: "your-placement-id",
    backgroundColor: .white
)

// With custom loading view and presentation type
Muta.shared.displayPlacement(
    placementId: "your-placement-id",
    backgroundColor: .white,
    presentationType: .fade,
    loadingView: AnyView(
        VStack {
            Image("your-logo")
                .resizable()
                .frame(width: 100, height: 100)
            ProgressView()
            Text("Loading...")
        }
    )
)
```

## API Reference

### Muta.configure()

Initializes the SDK with your API key.

```swift
Muta.configure(apiKey: String)
```

### Muta.shared.displayPlacement()

Displays a placement in a modal overlay.

```swift
// Using SwiftUI Color
func displayPlacement(
    placementId: String,
    backgroundColor: Color = .white,
    presentationType: PresentationType = .slide,
    loadingView: AnyView? = nil
)

// Using hex color string
func displayPlacement(
    placementId: String,
    backgroundHexColor: String,
    presentationType: PresentationType = .slide,
    loadingView: AnyView? = nil
)
```

#### Parameters

- `placementId` (required): The ID of the placement to display
- `backgroundColor`/`backgroundHexColor` (optional): Background color that matches your first placement screen. Defaults to white.
- `presentationType` (optional): Animation style when showing the placement. Defaults to .slide
  - `.slide`: Slides up from the bottom
  - `.fade`: Fades in from transparent
  - `.none`: No animation
- `loadingView` (optional): A custom SwiftUI view to show while the placement is loading

## Example App

```swift
import SwiftUI
import MutaSDK

@main
struct YourApp: App {
    init() {
        Muta.configure(apiKey: "your-api-key")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Button("Show Placement") {
            Muta.shared.displayPlacement(
                placementId: "your-placement-id",
                backgroundColor: .white,
                presentationType: .fade,
                loadingView: AnyView(
                    VStack {
                        ProgressView()
                        Text("Loading...")
                    }
                )
            )
        }
    }
}
```

## User Input Collection

Muta allows you to collect user inputs during the placement flow. These inputs are automatically collected and made available through events.

### Example Usage

```swift
import MutaSDK

class YourViewController {
    var subscription: Subscription?
    
    func setupMuta() {
        // Listen for user input events
        subscription = Muta.shared.on { event in
            if case .userInputFinal(let event) = event {
                // Access text input values
                event.userInputs.textInputs.forEach { input in
                    print("Input from screen \(input.screenName): \(input.value)")
                }
                
                // Access multiple choice selections
                event.userInputs.multipleChoices.forEach { choice in
                    let selections = choice.selections.map { $0.choiceText }
                    print("Choices from screen \(choice.screenName): \(selections)")
                }
            }
        }
        
        // Show the placement
        Muta.shared.displayPlacement(
            placementId: "your-placement-id",
            backgroundColor: .white
        )
    }
    
    deinit {
        subscription?.remove()
    }
}
```

### Input Types

1. Text Inputs
```swift
struct TextInput {
    let screenIndex: Int
    let screenName: String
    let value: String
    let placeholder: String
    let isRequired: Bool
}
```

2. Multiple Choice
```swift
struct MultipleChoiceInput {
    let screenIndex: Int
    let screenName: String
    let isRequired: Bool
    let selections: [Selection]
}

struct Selection {
    let choiceText: String
    let choiceIndex: Int
}
```

## Analytics Integration

Muta provides a flexible event system that works with any analytics provider. Events are emitted during key user interactions.

### Example with Analytics Integration

```swift
import MutaSDK

class AnalyticsManager {
    var subscription: Subscription?
    
    func setupTracking() {
        subscription = Muta.shared.on { event in
            switch event {
            case .flowStarted(let event):
                Analytics.track("Flow Started", properties: [
                    "placement_id": event.placementId,
                    "flow_name": event.flowName ?? "",
                    "total_screens": event.totalScreens,
                    "timestamp": event.timestamp
                ])
                
            case .flowCompleted(let event):
                Analytics.track("Flow Completed", properties: [
                    "placement_id": event.placementId,
                    "flow_name": event.flowName,
                    "screen_index": event.screenIndex,
                    "total_screens": event.totalScreens,
                    "timestamp": event.timestamp
                ])
                
            // Handle other events...
            }
        }
    }
    
    deinit {
        subscription?.remove()
    }
}
```

## Error Handling

Muta automatically handles errors and provides detailed error events.

### Example Usage

```swift
import MutaSDK

class ErrorHandler {
    var subscription: Subscription?
    
    func setupErrorHandling() {
        subscription = Muta.shared.on { event in
            switch event {
            case .flowStarted(let event):
                print("""
                    📊 Flow Started:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName ?? "N/A")
                    - Total Screens: \(event.totalScreens)
                    """)
                    
            case .screenViewed(let event):
                print("""
                    👀 Screen Viewed:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName ?? "N/A")
                    - Screen Index: \(event.screenIndex)
                    - Total Screens: \(event.totalScreens)
                    - Screen Name: \(event.screenName ?? "N/A")
                    """)
                    
            case .flowCompleted(let event):
                print("""
                    ✅ Flow Completed:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName)
                    - Screen Index: \(event.screenIndex)
                    - Total Screens: \(event.totalScreens)
                    - Screen Name: \(event.screenName)
                    """)
                    
            case .flowAbandoned(let event):
                print("""
                    ❌ Flow Abandoned:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName ?? "N/A")
                    - Screen Index: \(event.screenIndex)
                    - Total Screens: \(event.totalScreens)
                    - Last Screen Index: \(event.lastScreenIndex)
                    - Screen Name: \(event.screenName ?? "N/A")
                    """)
                    
            case .userInputFinal(let event):
                print("""
                    📝 User Input Final:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName ?? "N/A")
                    """)
                    
                // Multiple Choice Inputs
                event.userInputs.multipleChoices.forEach { choice in
                    print("""
                        🔘 Multiple Choice:
                        - Screen Index: \(choice.screenIndex)
                        - Screen Name: \(choice.screenName)
                        - Required: \(choice.isRequired)
                        - Selections: \(choice.selections.map { "[\($0.choiceText): \($0.choiceIndex)]" }.joined(separator: ", "))
                        """)
                }
                    
                // Text Inputs
                event.userInputs.textInputs.forEach { input in
                    print("""
                        📝 Text Input:
                        - Screen Index: \(input.screenIndex)
                        - Screen Name: \(input.screenName)
                        - Value: \(input.value)
                        - Placeholder: \(input.placeholder)
                        - Required: \(input.isRequired)
                        """)
                }
                    
            case .error(let error):
                switch error {
                case .network(let message, let timestamp):
                    print("""
                        🌐 Network Error:
                        - Message: \(message)
                        - Timestamp: \(timestamp)
                        """)
                        
                case .placement(let message, let code, let timestamp, let placementId):
                    print("""
                        ⚠️ Placement Error:
                        - Message: \(message)
                        - Code: \(code)
                        - Timestamp: \(timestamp)
                        - Placement ID: \(placementId)
                        """)
                @unknown default:
                    print("❓ Unknown Error Type")
                }
            @unknown default:
                print("❓ Unknown Event Type")
            }
        }
    }
    
    deinit {
        subscription?.remove()
    }
}
```

### Error Types

1. Network Errors
```swift
case network(message: String, timestamp: Int)
// Occurs when there's no internet connection
```

2. Placement Errors
```swift
case placement(message: String, code: String, timestamp: Int, placementId: String)
// Occurs when:
// - Placement ID or API Key is incorrect
// - Web encounters an error
```

### Common Error Codes

- `placement_error`: General placement error
- `unknown_error`: Unknown error from web

## Available Events

The SDK emits various events that you can listen to:

1. Flow Started
```swift
case flowStarted(FlowStartedEvent)
// Properties: placementId, flowName?, totalScreens, timestamp
```

2. Screen Viewed
```swift
case screenViewed(ScreenViewedEvent)
// Properties: placementId, flowName?, screenIndex, totalScreens, screenName?, timestamp
```

3. Flow Completed
```swift
case flowCompleted(FlowCompletedEvent)
// Properties: placementId, flowName, screenIndex, totalScreens, screenName, timestamp
```

4. Flow Abandoned
```swift
case flowAbandoned(FlowAbandonedEvent)
// Properties: placementId, flowName?, screenIndex, totalScreens, lastScreenIndex, screenName?, timestamp
```

5. User Input Final
```swift
case userInputFinal(UserInputFinalEvent)
// Properties: placementId, flowName?, timestamp, userInputs
```

6. Error Events
```swift
case error(ErrorEvent)
// Types: .network(message, timestamp) or .placement(message, code, timestamp, placementId)
```

### Subscribing to Specific Events

```swift
// Subscribe to all events
let subscription = Muta.shared.on { event in
    // Handle any event
}

// Subscribe to specific event type
let flowCompletedSubscription = Muta.shared.on(Muta.FlowCompletedEvent.self) { event in
    // Handle flow completed event
}

// Don't forget to remove subscriptions when done
subscription.remove()
flowCompletedSubscription.remove()
``` 