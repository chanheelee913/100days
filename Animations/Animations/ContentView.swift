//
//  ContentView.swift
//  Animations
//
//  Created by 이찬희 on 12/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isShowingRed = false
    var body: some View {
        
        
        VStack {
            Button("tap me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

#Preview {
    ContentView()
}
