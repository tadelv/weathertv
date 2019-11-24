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

    var body: some View {
        VStack {
            if (self.animating) {
                AnimatedImageView(image)
            }
            Text("Hello, World!")
        }.onAppear {
            let worker = GifDownloader()
            worker.fetchFreshGifData { (data, error) in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                guard let data = data else {
                    print("No data... abort!")
                    return
                }
                guard let image = UIImage.gif(data: data) else {
                    fatalError("Could not create gif UIImage")
                }
                self.image = image
                self.animating = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
