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
1. File > Add Package Dependencies
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
    loadingView: AnyView? = nil,
    injectedScreens: [InjectedScreen] = []
)

// Using hex color string
func displayPlacement(
    placementId: String,
    backgroundHexColor: String,
    presentationType: PresentationType = .slide,
    loadingView: AnyView? = nil,
    injectedScreens: [InjectedScreen] = []
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
- `injectedScreens` (optional): Array of native SwiftUI views to inject into code screens (see Code Screens section below)

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

## Custom Events

Muta allows you to emit custom events from your flows using the platform's behavior system. You can configure custom events in the Muta web editor and listen for them in your app to trigger specific actions.

### Setting Up Custom Events

1. In the Muta web editor, add an "Emit Event" behavior to any element
2. Give your event a unique name (e.g., `signup_started`, `premium_selected`, `survey_completed`)
3. Optionally add custom data to pass along with the event

### Example Usage

```swift
import MutaSDK

class YourViewController {
    var subscription: Subscription?
    
    func setupMuta() {
        // Listen for custom events
        subscription = Muta.shared.on { event in
            if case .custom(let customEvent) = event {
                switch customEvent.type {
                case "signup_started":
                    print("User started signup process")
                    navigateToSignup()
                    
                case "premium_selected":
                    if let planType = customEvent.eventData?["planType"] as? String,
                       let price = customEvent.eventData?["price"] as? Double {
                        print("User selected \(planType) plan at $\(price)")
                        setPremiumUser(true)
                    }
                    
                case "survey_completed":
                    if let answers = customEvent.eventData?["answers"] as? [String: Any] {
                        print("Survey completed with answers: \(answers)")
                        saveSurveyData(answers)
                    }
                    
                case "form_submitted":
                    if let formData = customEvent.eventData {
                        processFormData(formData)
                    }
                    
                default:
                    print("Received custom event: \(customEvent.type)")
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

### Custom Event Structure

```swift
struct CustomEvent {
    let type: String           // Your custom event name
    let placementId: String    // ID of the placement
    let flowName: String?      // Name of the flow (if configured)
    let screenIndex: Int?      // Current screen index
    let timestamp: Int         // Unix timestamp in ms
    let eventData: [String: Any]?  // Custom data from the editor
}
```

### Common Use Cases

1. **User Actions**: Track when users click specific CTAs or make choices
2. **Navigation Control**: Trigger app navigation based on flow interactions
3. **Data Collection**: Gather form submissions or survey responses
4. **Feature Flags**: Enable/disable features based on onboarding choices
5. **Conversion Tracking**: Track specific conversion events for analytics

## Code Screens

Code Screens allow you to inject native SwiftUI views into your Muta flows. This enables you to combine remotely configured flows with custom native functionality like authentication forms, payment screens, or any complex native UI.

### How It Works

1. In the Muta web editor, add a "Code Screen" to your flow and give it a unique name (e.g., "Login Screen", "Payment Form")
2. Configure the navigation destinations for continue and back actions
3. In your app, pass the corresponding SwiftUI view when displaying the placement

### Example Usage

```swift
import MutaSDK

// Display placement with injected native screens
Muta.shared.displayPlacement(
    placementId: "onboarding",
    backgroundColor: .black,
    presentationType: .none,
    injectedScreens: [
        InjectedScreen(
            screenName: "Login Screen",  // Must match the name in Muta editor
            view: { context in
                AnyView(LoginScreen(context: context))
            }
        ),
        InjectedScreen(
            screenName: "Payment Form",   // Must match the name in Muta editor
            view: { context in
                AnyView(PaymentScreen(context: context))
            }
        )
    ]
)
```

### Creating a Code Screen View

Your view will receive a `CodeScreenContext` with navigation callbacks and flow data:

```swift
import SwiftUI
import MutaSDK

struct LoginScreen: View {
    let context: CodeScreenContext

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome Back")
                .font(.largeTitle)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button(action: handleLogin) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Sign In")
                }
            }
            .disabled(isLoading)

            Button("Back") {
                context.onBack()  // Navigate to configured back destination
            }
        }
        .padding()
    }

    private func handleLogin() {
        isLoading = true

        // Perform login
        Task {
            await loginUser(email: email, password: password)
            isLoading = false
            context.onContinue()  // Navigate to configured continue destination
        }
    }
}
```

### CodeScreenContext Structure

```swift
public struct CodeScreenContext {
    /// Navigate to the next screen configured in the flow
    public let onContinue: () -> Void

    /// Navigate to the previous screen configured in the flow
    public let onBack: () -> Void

    /// Current flow variables
    public let variables: [[String: Any]]

    /// Unique identifier for this screen
    public let screenId: String

    /// Position of this screen in the flow
    public let screenIndex: Int
}
```

### Benefits

- **Hybrid Flows**: Combine no-code screens with custom native screens
- **Seamless Transitions**: Native screens animate in/out matching your flow animations
- **Full Control**: Access to all native capabilities while maintaining remote configurability
- **Dynamic Routing**: Configure navigation destinations remotely without code changes

### Code Screen Events

When code screens are displayed or interacted with, the SDK emits specific events:

```swift
import MutaSDK

let subscription = Muta.shared.on { event in
    switch event {
    case .codeScreenDisplayed(let event):
        print("Code screen displayed: \(event.screenName)")

    case .codeScreenAction(let event):
        print("Code screen action: \(event.action)") // "continue" or "back"

    default:
        break
    }
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
                var properties: [String: Any] = [
                    "placement_id": event.placementId,
                    "flow_name": event.flowName,
                    "screen_index": event.screenIndex,
                    "total_screens": event.totalScreens,
                    "timestamp": event.timestamp
                ]

                // Include collected variables if present
                if let variables = event.eventData?["variables"] as? [String: Any] {
                    properties["variables"] = variables
                }

                Analytics.track("Flow Completed", properties: properties)
                
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
                var message = """
                    ✅ Flow Completed:
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName)
                    - Screen Index: \(event.screenIndex)
                    - Total Screens: \(event.totalScreens)
                    - Screen Name: \(event.screenName)
                    """

                if let variables = event.eventData?["variables"] as? [String: Any] {
                    message += "\n    - Variables: \(variables)"
                }

                print(message)
                    
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
                    
            case .codeScreenDisplayed(let event):
                print("""
                    🖥️ Code Screen Displayed:
                    - Screen ID: \(event.screenId)
                    - Screen Name: \(event.screenName)
                    - Timestamp: \(event.timestamp)
                    """)

            case .codeScreenAction(let event):
                print("""
                    🔘 Code Screen Action:
                    - Action: \(event.action)
                    - Screen ID: \(event.screenId)
                    - Screen Name: \(event.screenName)
                    - Timestamp: \(event.timestamp)
                    """)

            case .custom(let event):
                print("""
                    🎯 Custom Event:
                    - Type: \(event.type)
                    - Timestamp: \(event.timestamp)
                    - Placement ID: \(event.placementId)
                    - Flow Name: \(event.flowName ?? "N/A")
                    - Screen Index: \(event.screenIndex ?? -1)
                    - Event Data: \(event.eventData ?? [:])
                    """)

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
// Properties: placementId, flowName, screenIndex, totalScreens, screenName, timestamp, eventData?
// eventData contains variables collected during the flow: eventData?["variables"] as? [String: Any]
```

4. Flow Abandoned
```swift
case flowAbandoned(FlowAbandonedEvent)
// Properties: placementId, flowName?, screenIndex, totalScreens, lastScreenIndex, screenName?, timestamp
```

5. Code Screen Displayed
```swift
case codeScreenDisplayed(CodeScreenDisplayedEvent)
// Properties: screenId, screenName, timestamp
```

6. Code Screen Action
```swift
case codeScreenAction(CodeScreenActionEvent)
// Properties: action, screenId, screenName, timestamp
// action: "continue" or "back"
```

7. Custom Events
```swift
case custom(CustomEvent)
// Properties: type, placementId, flowName?, screenIndex?, timestamp, eventData?
```

8. Error Events
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