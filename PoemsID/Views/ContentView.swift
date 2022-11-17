//
//  ContentView.swift
//  PoemsID
//
//  Created by Rendi Wijiatmoko on 17/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .imageScale(.large)
                NavigationLink("Running Trade", destination: RunningTradeView())
            }
            .foregroundColor(.orange)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
