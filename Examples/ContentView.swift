//
//  ContentView.swift
//  Examples
//
//  Created by Computer on 1/4/25.
//

import SwiftUI
import ViewKit
import Xcore

struct ContentView: View {
  
  
  @State private var isPresented: Bool = false
  
  @State private var selectedDate = Date()
  
  let items = ["Item 1", "Item 2", "Item 3"]
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
        .onTapGesture {
          isPresented = true
        }
    }
    .padding()
    .task(id: isPresented, {
      if isPresented == false {
        print("AAAAAa")
      }

    })
    .safeOnChange(isPresented, perform: { oldValue, newValue in
      
    })
    .bottomPopup(isPresented: $isPresented) {
      CustomBottomSheet {
        Button("Option 1") {
          isPresented = false
        }
        Button("Option 2") {
          
        }
        Button("Option 3") {
          
        }
      } header: {
        Label("Sheet Title", systemImage: .tv)
          .font(.app(.title3))
      }
    }
//    .datePicker(isPresented: $isPresented, date: $selectedDate)
  }
}

#Preview {
  ContentView()
}
