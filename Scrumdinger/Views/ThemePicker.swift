//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by christian on 1/5/23.
//

import SwiftUI

struct ThemePicker: View {
    // communicates changes to theme within the theme picker back up to parent view
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    // tagging subview to differentiate in picker
                    .tag(theme)
            }
        }
        .pickerStyle(.wheel)
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        // creates a binding to an immutable value for preview
        ThemePicker(selection: .constant(.periwinkle))
    }
}
