//
//  NemaOkupantivWidgetLiveActivity.swift
//  NemaOkupantivWidget
//
//  Created by SHIN MIKHAIL on 25.01.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NemaOkupantivWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NemaOkupantivWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NemaOkupantivWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NemaOkupantivWidgetAttributes {
    fileprivate static var preview: NemaOkupantivWidgetAttributes {
        NemaOkupantivWidgetAttributes(name: "World")
    }
}

extension NemaOkupantivWidgetAttributes.ContentState {
    fileprivate static var smiley: NemaOkupantivWidgetAttributes.ContentState {
        NemaOkupantivWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NemaOkupantivWidgetAttributes.ContentState {
         NemaOkupantivWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NemaOkupantivWidgetAttributes.preview) {
   NemaOkupantivWidgetLiveActivity()
} contentStates: {
    NemaOkupantivWidgetAttributes.ContentState.smiley
    NemaOkupantivWidgetAttributes.ContentState.starEyes
}
