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
    }

    static private let gifUrlString = "https://www.arso.gov.si/vreme/napovedi%20in%20podatki/radar_anim.gif"

    func fetchFreshGifData(_ completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            guard let image = UIImage.gif(url: Self.gifUrlString) else {
                DispatchQueue.main.async {
                    completion(.failure(DownloaderError.invalidData))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
    }
}
