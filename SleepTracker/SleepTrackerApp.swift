//
//  SleepTrackerApp.swift
//  SleepTracker
//
//  Created by Peter Eysermans on 17/07/2020.
//

import SwiftUI

@main
struct SleepTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SleepModel())
        }
    }
}
