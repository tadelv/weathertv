//
//  MockProvider.swift
//  WeatherTV
//
//  Created by Vid Tadel on 6/30/22.
//  Copyright © 2022 Delta96. All rights reserved.
//

import Combine
import Foundation
import UIKit

struct MockProvider: RequestPublisherProviding {
    func dataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let url = Bundle.main.url(forResource: "homer", withExtension: "gif"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: URLError(.cannotLoadFromNetwork))
                .eraseToAnyPublisher()
        }
        return Just((data: data, response: URLResponse(url: url,
                                                       mimeType: nil,
                                                       expectedContentLength: 0,
                                                       textEncodingName: nil)))
        .setFailureType(to: URLError.self)
        .eraseToAnyPublisher()
    }
}

struct MockDownloader: GifProviding {
  var gifPublisher: AnyPublisher<UIImage, Error> {
    guard let url = Bundle.main.url(forResource: "homer", withExtension: "gif"),
          let data = try? Data(contentsOf: url),
          let image = UIImage.gif(data: data) else {
      return Fail(error: URLError(.cannotLoadFromNetwork))
        .eraseToAnyPublisher()
    }
    return Just(image)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
