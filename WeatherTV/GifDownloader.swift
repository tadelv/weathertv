//
//  GifDownloader.swift
//  WeatherTV
//
//  Created by Vid on 11/24/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation
import UIKit


final class GifDownloader {

    enum DownloaderError: Error {
        case invalidData
        case invalidUrl
    }

    static private let gifUrlString = "https://meteo.arso.gov.si/uploads/probase/www/observ/radar/si0-rm-anim.gif"

    private let session = URLSession.shared

    func fetchFreshGifData(_ completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let url = URL(string: Self.gifUrlString) else {
            completion(.failure(DownloaderError.invalidUrl))
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard let data = data,
            let image = UIImage.gif(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? DownloaderError.invalidData))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}
