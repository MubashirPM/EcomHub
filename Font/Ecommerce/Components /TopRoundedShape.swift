//
//  TopRoundedShape.swift
//  Ecommerce
//
//  Created by Mubashir PM on 11/02/26.
//

import Foundation
import SwiftUI

struct TopRoundedShape: Shape {
    var radius: CGFloat = 28

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
        )
    }
}
