//
//  ContentView.swift
//  AnimationSandbox
//
//  Created by Jaime Yesid Leon Parada on 23/05/22.
//

import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 0.0
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    
    let letters = Array("Hello SwiftUI")
    
    
    var body: some View {
        /*
        Text("Click Me")
            .onTapGesture {
                //animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: animationAmount))
            .padding(100)
            .onAppear{
                animationAmount = 2
            }
        
        VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Text("Click Me")
                .onTapGesture {
                    animationAmount += 1
                }
                .padding(40)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding(100)
                .scaleEffect(animationAmount)
        }
         
        Text("Click Me")
            .onTapGesture {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    animationAmount += 360
                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .padding(100)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 1.0, y: 0.0, z: 0.0))
         
        Color.red
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(200)
            .offset(dragAmount)
            .gesture(DragGesture()
                .onChanged{dragAmount = $0.translation}
                .onEnded{_ in
                    withAnimation(.spring()) {
                        dragAmount = .zero
                    }
                }
            )
         */
        
        //Animation text
        /*
        HStack(spacing: 0){
            ForEach(0..<letters.count, id: \.self){ num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(DragGesture()
            .onChanged{dragAmount = $0.translation}
            .onEnded{ _ in
                dragAmount = .zero
                enabled.toggle()
            }
        )
        .padding(200)
        
        VStack{
            Button("Click Me"){
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
        .frame(width: 300, height: 300)
        */
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }.onTapGesture {
            withAnimation {
                isShowingRed.toggle()
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

extension AnyTransition {
    static var pivot: AnyTransition{
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
