//
//  AppDelegate.swift
//  WeatherTV
//
//  Created by Vid on 11/23/19.
//  Copyright © 2019 Delta96. All rights reserved.
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

