//
//  AnimatedImageView.swift
//  WeatherTV
//
//  Created by Vid on 11/24/19.
//  Copyright © 2019 Delta96. All rights reserved.
//

import SwiftUI

struct AnimatedImageView: UIViewRepresentable {

    let animatedImage: UIImage

    init(_ image: UIImage) {
        animatedImage = image
    }

    func makeUIView(context: Self.Context) -> UIView {
        let contentView = UIImageView()
        contentView.clipsToBounds = true
        contentView.contentMode = .scaleAspectFit
        contentView.image = animatedImage
        contentView.startAnimating()
        return contentView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AnimatedImageView>) {

    }
}
