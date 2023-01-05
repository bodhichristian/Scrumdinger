//
//  MeetingFooterView.swift
//  Scrumdinger
//
//  Created by christian on 1/5/23.
//

import SwiftUI

struct MeetingFooterView: View {
    let speakers: [ScrumTimer.Speaker]
    var skipAction: () -> Void
    
    // ScrumTimer marks each speaker as completed after their time has expired
    // the first speaker not marked as completed becomes the active speaker
    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex(where: {!$0.isCompleted}) else { return nil }
        return index + 1
    }
    // checks if active speaker is last speaker
    // is true if the isCompleted property is true for each speaker except the last
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    // presents active speaker info
    // ex1: "Speaker 1 of 3"
    // prints "No more speakers" when the meeting exceeds the allotted time
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                Text(speakerText)
                Spacer()
                Button {
                    skipAction()
                } label: {
                    Image(systemName: "forward.fill")
                }
                .accessibilityLabel("Next speaker")
                }
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
