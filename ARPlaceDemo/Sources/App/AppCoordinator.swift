import SwiftUI

final class AppCoordinator: Coordinator {
    enum Route: Hashable {
        case ar
    }

    @Published var path = NavigationPath()

    @ViewBuilder
    func rootView() -> some View {
        NavigationStack(
            path: Binding(
                get: { self.path },
                set: { self.path = $0 }
            )
        ) {
            ARScreen(viewModel: ARViewModel(router: self))
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .ar:
                        ARScreen(viewModel: ARViewModel(router: self))
                    }
                }
        }
    }
}

extension AppCoordinator: ARRouter {
    func didRequestShowGridInfo() { }
}
