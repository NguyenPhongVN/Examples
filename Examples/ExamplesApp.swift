//
//  ExamplesApp.swift
//  Examples
//
//  Created by Computer on 1/4/25.
//

import SwiftUI
import Pow
import MijickPopups
import MijickNavigationView
import PopupView
import Xcore
import SwiftUIKit

@main
struct ExamplesApp: App {
    var body: some Scene {
        WindowGroup {
          RootView()
            .implementNavigationView()
        }
    }
}

struct ContentView3: NavigatableView {
  
  @State var switchingImages: [String] = Array(1...5).map(\.description)
  @State var randomInt: Int = 0
  
  var body: some View {
    VStack {
      ZStack {
        ForEach(switchingImages, id: \.self) { _ in
          Image(switchingImages[randomInt%5])
            .resizable()
            .frame(width: 300, height: 300)
        }
        
      }
      // This id tells SwiftUI to redraw the view, if ‘randomInt‘ changes
      .id(randomInt)
      // Here you can modify, what should the animation look like.
      // You can try changing the 'scale' in the next line to 'opacity', and see what looks best to you!
      .transition(.opacity.animation(.easeOut))
      //        .transition(.scale.animation(.easeOut).combined(with: .opacity))
      Button {
        randomInt += 1
      } label: {
        Text("Change Image")
      }
    }
  }
}

struct ContentView2: NavigatableView {
  
//  private let colors = Array(1...5).map(\.description).map({Image($0).resizable()})
  private let colors = [Color.red, Color.green, Color.blue, Color.teal, Color.yellow]
  private let maxScaleEffect: CGFloat = 1
  private let minScaleEffect: CGFloat = 0
  private let animationDuration = 2.0
  private let animationDelay = 0.1
  
  @State private var shouldTransition = true
  @State private var colorIndex = 0
  
  var body: some View {
    VStack {
      ZStack {
        previousColor
          .scaledToFit()
        //          .frame(200)
        //        .fill(previousColor)
          .scaleEffect(maxScaleEffect)
        if shouldTransition {
          transitioningColor
            .scaledToFit()
//            .modifier(RippleEffect(at: UIScreen.main.bounds.origin, trigger: colorIndex))
//                    .scaleEffect(shouldTransition ? maxScaleEffect : minScaleEffect)
//                      .opacity(shouldTransition ? 1 : 0)
//                      .transition(.movingParts.wipe(
//                        angle: .degrees(-45),
//                        blurRadius: 50
//                      ))
//                      .transition(.movingParts.wipe(edge: .leading))
          //            .transition(.movingParts.snapshot)
          //            .transition(.movingParts.iris(
          //              blurRadius: 50
          //            ))
          //            .transition(.movingParts.glare(angle: .degrees(45), color: .white.opacity(0.3), increasedBrightness: false))
          //            .transition(
          //              .movingParts.vanish(.white)
          //            )
                      .transition(.movingParts.filmExposure)
//            .transition(.movingParts.clock(
//              blurRadius: 50
//            ))
        }
        
        
      }
      .clipped()
      
      Button("Change color") {
        shouldTransition = false
        colorIndex += 1
        
        // Removing DispatchQueue here will cause the first transition not to work
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
          withAnimation(.easeInOut(duration: animationDuration)) {
            shouldTransition = true
          }
        }
      }
      .foregroundColor(.primary)
    }
  }
  
  private var previousColor: some View {
    colors[colorIndex%colors.count]
  }
  
  private var transitioningColor: some View {
    colors[(colorIndex+1)%colors.count]
  }
}

/// A modifer that performs a ripple effect to its content whenever its
/// trigger value changes.
struct RippleEffect<T: Equatable>: ViewModifier {
  var origin: CGPoint
  
  var trigger: T
  
  init(at origin: CGPoint, trigger: T) {
    self.origin = origin
    self.trigger = trigger
  }
  
  func body(content: Content) -> some View {
    let origin = origin
    let duration = duration
    
    content.keyframeAnimator(
      initialValue: 0,
      trigger: trigger
    ) { view, elapsedTime in
      view.modifier(RippleModifier(
        origin: origin,
        elapsedTime: elapsedTime,
        duration: duration
      ))
    } keyframes: { _ in
      MoveKeyframe(0)
      LinearKeyframe(duration, duration: duration)
    }
  }
  
  var duration: TimeInterval { 3 }
}

/// A modifier that applies a ripple effect to its content.
struct RippleModifier: ViewModifier {
  var origin: CGPoint
  
  var elapsedTime: TimeInterval
  
  var duration: TimeInterval
  
  var amplitude: Double = 12
  var frequency: Double = 15
  var decay: Double = 8
  var speed: Double = 2000
  
  func body(content: Content) -> some View {
    let shader = ShaderLibrary.Ripple(
      .float2(origin),
      .float(elapsedTime),
      
      // Parameters
      .float(amplitude),
      .float(frequency),
      .float(decay),
      .float(speed)
    )
    
    let maxSampleOffset = maxSampleOffset
    let elapsedTime = elapsedTime
    let duration = duration
    
    content.visualEffect { view, _ in
      view.layerEffect(
        shader,
        maxSampleOffset: maxSampleOffset,
        isEnabled: 0 < elapsedTime && elapsedTime < duration
      )
    }
  }
  
  var maxSampleOffset: CGSize {
    CGSize(width: amplitude, height: amplitude)
  }
}
