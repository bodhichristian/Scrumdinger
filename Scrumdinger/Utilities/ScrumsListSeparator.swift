//
//  ScrumsListSeparator.swift
//  Scrumdinger
//
//  Created by christian on 1/7/23.
//

import Foundation
import SwiftUI

struct ScrumsListSeparator: ViewModifier {
    
    // hides row separator if user is running iOS 15 or newer
    // if user is running previous versions, content is returned unmodified
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .listRowSeparator(.hidden)
        } else {
            content
        }
    }
}
