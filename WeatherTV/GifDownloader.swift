//
//  GifDownloader.swift
//  WeatherTV
//
//  Created by Vid on 11/24/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Combine
import Foundation
import UIKit

public protocol RequestPublisherProviding {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: RequestPublisherProviding {
  public func dataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        let publisher: DataTaskPublisher = dataTaskPublisher(for: url)
        return publisher.eraseToAnyPublisher()
    }
}

public protocol GifProviding {
  var gifPublisher: AnyPublisher<UIImage, Error> { get }
}

public final class GifDownloader: GifProviding {

    enum DownloaderError: Error {
        case invalidData
        case invalidUrl
    }

    static private let gifUrlString = "https://meteo.arso.gov.si/uploads/probase/www/observ/radar/si0-rm-anim.gif"

    private let session = URLSession.shared
    private let publisherProvider: RequestPublisherProviding

    public init(provider: RequestPublisherProviding) {
        publisherProvider = provider
    }

  public var gifPublisher: AnyPublisher<UIImage, Error> {
        guard let url = URL(string: Self.gifUrlString) else {
            return Fail(error: DownloaderError.invalidUrl)
                .eraseToAnyPublisher()
        }
        return publisherProvider.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> UIImage in
                guard let image = UIImage.gif(data: data) else {
                    throw DownloaderError.invalidData
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}
