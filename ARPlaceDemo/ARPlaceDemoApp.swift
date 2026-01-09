//
//  ARPlaceDemoApp.swift
//  ARPlaceDemo
//
//  Created by Daria Len on 09.01.2026.
//

import SwiftUI

@main
struct ARPlaceDemoApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.rootView()
        }
    }
}
