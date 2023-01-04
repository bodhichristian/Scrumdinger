//
//  TrailingIconLabelStyle.swift
//  Scrumdinger
//
//  Created by christian on 1/3/23.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    
    // returns a view that presents label image to the trailing side of label text
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            // label text
            configuration.title
            
            // label image
            configuration.icon
        }
    }
}

// allows label style to be called using leading dot syntax
// .labelStyle(.trailingIcon)
extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
