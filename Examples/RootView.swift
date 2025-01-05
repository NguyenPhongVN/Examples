//
//  RootView.swift
//  Examples
//
//  Created by Computer on 1/5/25.
//

import SwiftUI
import MijickNavigationView

struct RootView: NavigatableView {
    var body: some View {
        Text("Hello, World!")
        .onTap {
          ContentView2()
            .push(with: .verticalSlide)
        }
    }
}

#Preview {
    RootView()
}
