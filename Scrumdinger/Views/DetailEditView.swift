//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by christian on 1/4/23.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var data: DailyScrum.Data
    @State private var newAttendeeName = ""
    
    var body: some View {
        Form {
            Section(header: Text("Meeting Info")) {
                TextField("Title", text: $data.title)
                HStack {
                    // slider ranging 5 - 30, whole numbers only
                    Slider(value: $data.lengthInMinutes, in: 5...30, step: 1) {
                        // VoiceOver label
                        Text("Length")
                    }
                    .accessibilityValue("\(Int(data.lengthInMinutes)) minutes")
                    Spacer()
                    Text("\(Int(data.lengthInMinutes)) min")
                        .accessibilityHidden(true)
                }
                ThemePicker(selection: $data.theme)
                    .padding(-20)
            }
            
            Section(header: Text("Attendees")) {
                HStack {
                    TextField("New Attendee", text: $newAttendeeName)
                    Button {
                        withAnimation {
                            // appends user input to data.attendees array
                            let attendee = DailyScrum.Attendee(name: newAttendeeName)
                            data.attendees.append(attendee)
                            newAttendeeName = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty)
                }
                
                ForEach(data.attendees) { attendee in
                    Text(attendee.name)
                }
                .onDelete { indices in
                    data.attendees.remove(atOffsets: indices)
                }
                
            }
            
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(data: .constant(DailyScrum.sampleData[0].data))
    }
}
