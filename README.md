# ARPlacementDemo (SwiftUI + ARKit)

A minimal, business-free ARKit demo that shows **plane detection + focus square + object placement** using:

- **SwiftUI** as the UI layer
- **ARSCNView** wrapped via `UIViewRepresentable`
- **MVVM + Coordinator**
- A **Clean Architecture-ish** folder split (`Presentation / Domain / Data`) while keeping it lightweight

> This repo is intentionally small and readable so it can be used as a portfolio demo or a test assignment base.

---

## Features

- AR session setup (world tracking)
- Horizontal/vertical raycast query support
- Focus square (pulse/open effect)
- Detected plane visualisation (wireframe shader)
- Tap to place a simple `SCNBox` (as a placeholder virtual object)
- Long-press + pan can be extended (hooks are included)
