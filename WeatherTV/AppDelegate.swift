//
//  AppDelegate.swift
//  WeatherTV
//
//  Created by Vid on 11/23/19.
//  Copyright © 2019 Delta96. All rights reserved.
//
import SwiftUI

@main
struct WeatherTVApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(worker: GifDownloader(provider: URLSession.shared))
        }
    }
}

