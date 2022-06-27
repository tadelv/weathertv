//
//  WatchView.swift
//  WeatherWatch WatchKit Extension
//
//  Created by Vid Tadel on 6/25/22.
//  Copyright © 2022 Delta96. All rights reserved.
//

import SwiftUI

struct WatchView: View {
    @State var image: UIImage?
    @State var message: String?
    @State var index = 0

    private let downloader: GifDownloader

    internal init(downloader: GifDownloader) {
        self.downloader = downloader
    }

    var body: some View {
        ZStack {
            if let images = image?.images,
               let image = images[index] {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                VStack {
                    ProgressView()
                    Text(message ?? "")
                }
            }
        }.onAppear {
            downloader.fetchFreshGifData { result in
                switch result {
                case .failure(let error):
                    message = "Failed: \(error)"
                case .success(let image):
                    self.image = image
                    let count = image.images?.count ?? 1
                    let interval = image.duration / Double(count)
                    Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                        if index < count - 1 {
                            index += 1
                        } else {
                            index = 0
                        }
                    }
                }
            }
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView(downloader: GifDownloader())
    }
}
