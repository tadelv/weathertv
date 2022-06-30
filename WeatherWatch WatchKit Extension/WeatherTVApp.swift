//
//  WeatherTVApp.swift
//  WeatherWatch WatchKit Extension
//
//  Created by Vid Tadel on 6/25/22.
//  Copyright © 2022 Delta96. All rights reserved.
//

import SwiftUI
import WeatherKit

@main
struct WeatherTVApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(downloader: GifDownloader(provider: URLSession.shared))
        }
    }
}
