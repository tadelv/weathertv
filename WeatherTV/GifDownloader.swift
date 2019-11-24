//
//  GifDownloader.swift
//  WeatherTV
//
//  Created by Vid on 11/24/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import Foundation


final class GifDownloader {

    static private let gifUrlString = "https://www.arso.gov.si/vreme/napovedi%20in%20podatki/radar_anim.gif"

    func fetchFreshGifData(_ completion: @escaping ((Data?,Error?) -> Void)) {
        guard let url = URL(string: GifDownloader.gifUrlString) else {
            fatalError("Could not build url from \(GifDownloader.gifUrlString)")
        }
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }

        }
    }
}
