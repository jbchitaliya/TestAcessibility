

### SwiftUI Accessibility Interview Prep — Expanded Problem Set

Below is a curated list of **15 interview-style SwiftUI accessibility coding problems** with concise solutions and code snippets. Each problem targets a common accessibility pitfall or concept you’re likely to be asked about in interviews: **labels, traits, dynamic type, VoiceOver ordering, focus, contrast, custom actions, accessibility notifications, localization, and testing**. Use these as practice prompts: explain the issue, write the fix, and discuss why it improves accessibility.

---

### Quick reference table (attributes to compare)
| **Problem** | **Key concept** | **Why it matters** |
|---|---:|---|
| Icon-only controls | Accessibility label | Screen readers need meaningful text |
| Fixed fonts | Dynamic Type | Respect user text-size preferences |
| Decorative images | Hidden from accessibility | Reduce noise for VoiceOver users |
| Grouped content | Combine children | Read as a single logical unit |
| Complex controls | Accessibility traits | Convey control type and state |
| Custom gestures | Custom actions | Make gestures accessible via actions |
| Focus order | Accessibility sort order | Logical navigation for VoiceOver |
| Color-only cues | Contrast & non-color cues | Users with low vision or color blindness |
| Live updates | Accessibility notifications | Inform assistive tech of dynamic changes |
| Form validation | Accessibility hints & errors | Guide users to fix input issues |
| Dynamic lists | Accessibility identifiers | Testability and UI testing |
| Image descriptions | Accessibility label vs value | Convey meaning succinctly |
| Switch-like buttons | Accessibility value | Communicate on/off state |
| Modal presentation | Accessibility focus movement | Move VoiceOver focus to modal content |
| Localization | Localized accessibility labels | Support users in their language |

---

## Problems and Solutions

### Problem 1 — Icon-only control (expanded)
**Question:** A toolbar has icon-only buttons (trash, edit, share). VoiceOver reads only the system image name. How do you make them accessible and concise for multiple locales?

**Solution:**
```swift
Button(action: deleteItem) {
    Image(systemName: "trash")
}
.accessibilityLabel(Text("Delete"))
.accessibilityHint(Text("Deletes the selected item"))
```
**Why:** `accessibilityLabel` provides a localized, human-friendly label; `accessibilityHint` gives extra context. Use `LocalizedStringKey` or `NSLocalizedString` for localization.



---

### Problem 2 — Respect Dynamic Type
**Question:** A headline uses `.font(.system(size: 16))`. How to support Dynamic Type?

**Solution:**
```swift
Text("Welcome")
    .font(.headline)
    .dynamicTypeSize(... ) // optional: limit range if needed
```
**Why:** Semantic fonts scale automatically with user settings.

---

### Problem 3 — Decorative images announced by VoiceOver
**Question:** Background pattern images are announced by VoiceOver. How to hide them?

**Solution:**
```swift
Image("pattern")
    .accessibilityHidden(true)
```
**Why:** Hides purely decorative visuals from assistive tech.

---

### Problem 4 — Combine related text elements
**Question:** Price label and value are separate `Text` views and read separately. Combine them.

**Solution:**
```swift
VStack {
    Text("Price")
    Text("$9.99")
}
.accessibilityElement(children: .combine)
```
**Why:** VoiceOver reads them as one logical phrase.

---

### Problem 5 — Convey control role and state
**Question:** A custom view behaves like a toggle but is implemented with a `Button`. How to expose role and state?

**Solution:**
```swift
struct FavoriteButton: View {
    @State var isFavorite: Bool
    var body: some View {
        Button(action: { isFavorite.toggle() }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
        }
        .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(Text(isFavorite ? "On" : "Off"))
    }
}
```
**Why:** Traits and values let assistive tech describe behavior and state.

---

### Problem 6 — Custom gestures inaccessible
**Question:** A view uses a two-finger rotate gesture to perform an action. VoiceOver users can’t perform it. How to provide an accessible alternative?

**Solution:**
```swift
Rectangle()
    .gesture(RotationGesture().onEnded { _ in rotateAction() })
    .accessibilityAction(named: Text("Rotate")) {
        rotateAction()
    }
```
**Why:** `accessibilityAction` exposes the action to VoiceOver users via the rotor/action menu.

---

### Problem 7 — VoiceOver focus order is wrong
**Question:** VoiceOver reads elements in an unexpected order because of layout. How to control it?

**Solution:**
```swift
VStack {
    Text("Header")
        .accessibilitySortPriority(1)
    Text("Body")
        .accessibilitySortPriority(0)
    Button("Next") { }
        .accessibilitySortPriority(2)
}
```
**Why:** `accessibilitySortPriority` influences traversal order when layout order isn’t ideal.

---

### Problem 8 — Color-only status indicator
**Question:** A status dot uses color only (green/red). How to make it accessible?

**Solution:**
```swift
Circle()
    .fill(isOnline ? Color.green : Color.red)
    .frame(width: 12, height: 12)
    .accessibilityLabel(Text("Status"))
    .accessibilityValue(Text(isOnline ? "Online" : "Offline"))
```
**Why:** Non-color cues (labels/values) convey status to users with color vision deficiencies.

---

### Problem 9 — Live region updates (dynamic content)
**Question:** A score label updates frequently; VoiceOver doesn’t announce changes. How to notify?

**Solution:**
```swift
Text("Score: \(score)")
    .accessibilityLabel("Score")
    .accessibilityValue(Text("\(score)"))
    .accessibilityLiveRegion(.polite)
```
**Why:** Live regions prompt assistive tech to announce dynamic changes.

---

### Problem 10 — Form validation feedback
**Question:** After submitting a form, validation errors appear visually but aren’t announced. How to surface them?

**Solution:**
```swift
if let error = emailError {
    Text(error)
        .foregroundColor(.red)
        .accessibilityLabel(Text("Email error"))
        .accessibilityValue(Text(error))
        .accessibilityAddTraits(.isStaticText)
        .accessibilityFocused($errorFocus) // move focus if appropriate
}
```
**Why:** Announcing errors and moving focus helps users correct inputs.

---

### Problem 11 — Accessibility identifiers for UI tests
**Question:** You need stable identifiers for UI tests and accessibility. How to set them?

**Solution:**
```swift
Button("Submit") { submit() }
    .accessibilityIdentifier("submitButton")
    .accessibilityLabel("Submit")
```
**Why:** `accessibilityIdentifier` is for testing; `accessibilityLabel` is for users.

---

### Problem 12 — Image needs descriptive text
**Question:** An image conveys important content (e.g., chart). How to provide a concise description?

**Solution:**
```swift
Image("salesChart")
    .resizable()
    .scaledToFit()
    .accessibilityLabel(Text("Sales chart"))
    .accessibilityValue(Text("Sales increased 20% in Q2 compared to Q1"))
```
**Why:** Keep labels concise; use `accessibilityValue` for additional data.

---

### Problem 13 — Toggle implemented as custom button
**Question:** A custom-styled toggle uses a `Button`. How to expose it as a toggle to assistive tech?

**Solution:**
```swift
Button(action: { isOn.toggle() }) {
    HStack {
        Text("Notifications")
        Spacer()
        Circle().fill(isOn ? Color.blue : Color.gray)
    }
}
.accessibilityLabel(Text("Notifications"))
.accessibilityValue(Text(isOn ? "On" : "Off"))
.accessibilityAddTraits(isOn ? .isSelected : [])
.accessibilityHint(Text("Double tap to toggle"))
```
**Why:** Values and traits communicate toggle semantics.

---

### Problem 14 — Modal presentation focus
**Question:** Presenting a modal sheet; VoiceOver focus remains on background. How to move focus to modal content?

**Solution:**
```swift
.sheet(isPresented: $showModal) {
    ModalView()
        .onAppear {
            UIAccessibility.post(notification: .screenChanged, argument: UIAccessibilityElement())
        }
}
```
**Why:** Posting `.screenChanged` moves VoiceOver focus to the modal. Alternatively, set an initial focused element inside the modal.

---

### Problem 15 — Localization of accessibility strings
**Question:** Accessibility labels are hard-coded in English. How to localize them?

**Solution:**
```swift
Button(action: {}) {
    Image(systemName: "trash")
}
.accessibilityLabel(Text(LocalizedStringKey("delete_button_label")))
```
**Why:** Use `LocalizedStringKey` or `NSLocalizedString` to provide localized labels and hints.



---

## How to use this list for interview prep
1. **Practice explaining** each problem in 60–90 seconds: describe the issue, the accessibility API used, and why it helps.
2. **Write code live**: implement one or two problems in a sample SwiftUI app; run with VoiceOver on the simulator or device.
3. **Test with VoiceOver**: enable VoiceOver and navigate your UI; note phrasing and order.
4. **Discuss trade-offs**: e.g., when to use `accessibilityHidden(true)` vs. providing a short label; when to post `.screenChanged`.
5. **Prepare follow-ups**: interviewers often ask about localization, testing, and performance implications.

---
| **Modifier** | **Purpose** | **Sample Code** |
| --- | --- | --- |
| **[accessibilityLabel](ca://s?q=SwiftUI_accessibilityLabel)** | Provides a spoken description for VoiceOver users. | ``swift ``Text("⚠️") ``.accessibilityLabel("Warning")`` |
| **[accessibilityHint](ca://s?q=SwiftUI_accessibilityHint)** | Adds extra guidance about what an element does. | ``swift ``Button("Submit") ``{} ``.accessibilityHint("Sends ``the ``form")`` |
| **[accessibilityValue](ca://s?q=SwiftUI_accessibilityValue)** | Announces the current value/state of a control. | ``swift ``Toggle("Wi-Fi", ``isOn: ``$wifi) ``.accessibilityValue(wifi ``? ``"On" ``: ``"Off")`` |
| **[accessibilityHidden](ca://s?q=SwiftUI_accessibilityHidden)** | Hides decorative or irrelevant elements from accessibility. | ``swift ``Image("pattern") ``.accessibilityHidden(true)`` |
| **[accessibilityElement](ca://s?q=SwiftUI_accessibilityElement)** | Groups multiple child views into one accessibility element. | ``swift ``VStack ``{ ``Text("Price") ``Text("$9.99") ``} ``.accessibilityElement(children: ``.combine)`` |
| **[accessibilityAddTraits](ca://s?q=SwiftUI_accessibilityAddTraits)** | Adds traits like ``.isButton``, ``.isHeader``, ``.isSelected``. | ``swift ``Text("Title") ``.accessibilityAddTraits(.isHeader)`` |
| **[accessibilityRemoveTraits](ca://s?q=SwiftUI_accessibilityRemoveTraits)** | Removes default traits from an element. | ``swift ``Button("Link") ``{} ``.accessibilityRemoveTraits(.isButton)`` |
| **[accessibilitySortPriority](ca://s?q=SwiftUI_accessibilitySortPriority)** | Controls VoiceOver reading order. | ``swift ``Text("Header") ``.accessibilitySortPriority(1)`` |
| **[accessibilityAction](ca://s?q=SwiftUI_accessibilityAction)** | Defines custom actions accessible via VoiceOver rotor. | ``swift ``Rectangle() ``.accessibilityAction(named: ``Text("Rotate")) ``{ ``rotate() ``}`` |
| **[accessibilityIdentifier](ca://s?q=SwiftUI_accessibilityIdentifier)** | Provides a stable identifier for UI testing. | ``swift ``Button("Login") ``{} ``.accessibilityIdentifier("loginButton")`` |
| **[accessibilityFocused](ca://s?q=SwiftUI_accessibilityFocused)** | Moves VoiceOver focus programmatically. | ``swift ``Text("Error") ``.accessibilityFocused($errorFocus)`` |
| **[accessibilityAdjustableAction](ca://s?q=SwiftUI_accessibilityAdjustableAction)** | Adds increment/decrement actions for custom controls. | ``swift ``CustomStepper() ``.accessibilityAdjustableAction ``{ ``direction ``in ``if ``direction ``== ``.increment ``{ ``value ``+= ``1 ``} ``else ``{ ``value ``-= ``1 ``} ``}`` |
| **[accessibilityChildren](ca://s?q=SwiftUI_accessibilityChildren)** | Controls how child elements are exposed. | ``swift ``VStack ``{ ``Text("Name") ``Text("John") ``} ``.accessibilityChildren(.combine)`` |
| **[accessibilityRepresentation](ca://s?q=SwiftUI_accessibilityRepresentation)** | Provides a custom accessibility representation for a view. | ``swift ``MyCustomView() ``.accessibilityRepresentation ``{ ``Text("Custom ``control") ``}`` |
| **[accessibilityRotor](ca://s?q=SwiftUI_accessibilityRotor)** | Creates custom VoiceOver rotor navigation. | ``swift ``.accessibilityRotor("Headings") ``{ ``element ``in ``element.accessibilityTraits.contains(.isHeader) ``}`` |
| **[accessibilityScrollAction](ca://s?q=SwiftUI_accessibilityScrollAction)** | Defines scroll actions for custom scrollable views. | ``swift ``ScrollView ``{ ``... ``} ``.accessibilityScrollAction ``{ ``edge ``in ``scrollTo(edge) ``}`` |
| **[accessibilityTextContentType](ca://s?q=SwiftUI_accessibilityTextContentType)** | Specifies semantic meaning of text (e.g., username, password). | ``swift ``TextField("Username", ``text: ``$name) ``.accessibilityTextContentType(.username)`` |
| **[accessibilityLabeledBy](ca://s?q=SwiftUI_accessibilityLabeledBy)** | Associates a view with another view as its label. | ``swift ``HStack ``{ ``Text("Volume") ``Slider(value: ``$volume) ``.accessibilityLabeledBy(Text("Volume")) ``}`` |
| **[accessibilityValueDescription](ca://s?q=SwiftUI_accessibilityValueDescription)** | Provides descriptive value text for custom controls. | ``swift ``ProgressView(value: ``0.5) ``.accessibilityValue(Text("Half ``complete"))`` |
