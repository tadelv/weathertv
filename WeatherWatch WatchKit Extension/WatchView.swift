//
//  WeatherView.swift
//  WeatherWatch WatchKit Extension
//
//  Created by Vid Tadel on 6/25/22.
//  Copyright © 2022 Delta96. All rights reserved.
//

import Combine
import SwiftUI

public struct WeatherView: View {

    @Environment(\.scenePhase) var scenePhase

    @ObservedObject
    private var viewModel: ViewModel

    public init(downloader: GifProviding) {
        viewModel = ViewModel(downloader: downloader)
    }

    public var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                VStack {
                    ProgressView()
                    Text(viewModel.message ?? "")
                }
            }
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                viewModel.runAnimation()
            case .inactive:
                viewModel.stopAnimation()
            case .background:
                viewModel.purge()
            @unknown default:
              break
            }
        }
#if os(watchOS)
        // somehow scenePhase doesn't change on the watch
        .onAppear {
          viewModel.runAnimation()
        }
#endif
    }


}

extension WeatherView {
    class ViewModel: ObservableObject {
        @Published
        var image: UIImage?

        @Published
        var message: String?

        private var index = 0
        private var timer: Timer?
        private var timerInterval: Double = 0
        private var images: [UIImage] = []

        private let downloader: GifProviding
        private var cancellable: AnyCancellable?

        init(downloader: GifProviding) {
            self.downloader = downloader
        }

        func runAnimation() {
            if images.isEmpty {
                loadAnimation()
            } else {
                beginAnimating()
            }
        }

        private func beginAnimating() {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.index < self.images.count - 1 {
                    self.index += 1
                } else {
                    self.index = 0
                }
                self.image = self.images[self.index]
            }
        }

        private func loadAnimation() {
            cancellable?.cancel()
            message = "Loading"
            image = nil
            index = 0
            timerInterval = 1
            cancellable = downloader.gifPublisher.receive(on: RunLoop.main)
                .sink { [weak self] value in
                    if case .failure(let error) = value {
                        self?.message = "Failed: \(error)"
                    }
                } receiveValue: { [weak self] newImage in
                    guard let self = self else {
                        return
                    }
                    self.images = newImage.images ?? []
                    let count = self.images.count
                    self.timerInterval = newImage.duration / Double(count)
                    self.beginAnimating()
                }
        }

        func stopAnimation() {
            timer?.invalidate()
        }

        func purge() {
            images = []
            index = 0
            image = nil
            message = "Paused"
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(downloader: MockDownloader())
    }
}
