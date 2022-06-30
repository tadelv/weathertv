//
//  WatchView.swift
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

    private var ignorePhase = false

    public init(downloader: GifProviding) {
        viewModel = ViewModel(downloader: downloader)
    }

    internal init(downloader: GifProviding, ignorePhase: Bool) {
        viewModel = ViewModel(downloader: downloader)
        self.ignorePhase = ignorePhase
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
                viewModel.loadAnimation()
            case .inactive:
                viewModel.stopAnimation()
            default:
                break
            }
        }.onAppear {
            if ignorePhase {
                viewModel.loadAnimation()
            }
        }
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
        private var images: [UIImage] = []

        private let downloader: GifProviding
        private var cancellable: AnyCancellable?

        init(downloader: GifProviding) {
            self.downloader = downloader
        }

        func loadAnimation() {
            image = nil
            index = 0
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
                    let count = newImage.images?.count ?? 1
                    let interval = newImage.duration / Double(count)
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                        if self.index < count - 1 {
                            self.index += 1
                        } else {
                            self.index = 0
                        }
                        self.image = self.images[self.index]
                    }
                }
        }

        func stopAnimation() {
            timer?.invalidate()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(downloader: MockDownloader(), ignorePhase: true)
            .previewDevice(.init(rawValue: "Apple Watch - 42mm"))
    }
}
