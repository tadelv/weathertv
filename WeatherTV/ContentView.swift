//
//  ContentView.swift
//  WeatherTV
//
//  Created by Vid on 11/23/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Combine
import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {

        @Published
        var image: UIImage?

        @Published
        var message: String?

        private let worker: GifDownloader
        private var cancellable: AnyCancellable?

        init(worker: GifDownloader) {
            self.worker = worker
        }

        func loadImage() {
            message = "Loading ..."
            cancellable =  worker.gifPublisher
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] error in
                    self?.message = "Failed with \(error)"
                }, receiveValue: { [weak self] image in
                    self?.image = image
                })
        }
    }
}

struct ContentView: View {
    @ObservedObject
    private var viewModel: ViewModel

    internal init(worker: GifDownloader) {
        viewModel = ViewModel(worker: worker)
    }

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                AnimatedImageView(image)
            } else {
                VStack {
                    ProgressView()
                    Text(viewModel.message ?? "")
                }
            }
        }.onAppear {
            viewModel.loadImage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(worker: GifDownloader(provider: MockProvider()))
            .environment(\.scenePhase, .active)
    }
}
