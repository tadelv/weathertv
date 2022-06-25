//
//  ContentView.swift
//  WeatherTV
//
//  Created by Vid on 11/23/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var image = UIImage()
    @State private var animating = false
    @State private var message = "Hello World"

    private let worker: GifDownloader

    internal init(worker: GifDownloader) {
        self.worker = worker
    }

    var body: some View {
        VStack {
            if (self.animating) {
                AnimatedImageView(image)
            }
            Text(message)
        }.onAppear {
            worker.fetchFreshGifData { result in
                switch result {
                case .failure(let error):
                    message = "Failed: \(error)"
                case .success(let image):
                    self.image = image
                    self.animating = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(worker: GifDownloader())
    }
}
