//
//  ContentView.swift
//  SwiftUIAnimationFancyButton
//
//  Created by Abdelrahman Mohamed on 31.08.2020.
//  Copyright © 2020 Abdelrahman Mohamed. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var progress: CGFloat = 0.0
    @State private var isProgressLoading = false
    
    @State private var isLoading = false
    
    @State private var processing = false
    @State private var completed = false
    @State private var loading = false
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            if processing && !completed {
                
                Group {
                    
                    ZStack {
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(Font.TextStyle.title, design: Font.Design.rounded))
                            .bold()
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Color.pink, lineWidth: 5)
                            .frame(width: 100, height: 100)
                            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                            //                    .animation(Animation.default.repeatForever(autoreverses: false))
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                            .onAppear() {
                                self.isLoading = true
                            }
                        
                        Circle()
                            .stroke(Color(.systemGray5), lineWidth: 10)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.pink, lineWidth: 10)
                            .frame(width: 200, height: 200)
                            .rotationEffect(Angle(degrees: -90))
                    }
                    .onAppear() {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            self.progress += 0.2
                            print(self.progress)
                            if self.isProgressLoading {
                                timer.invalidate()
                                self.progress = 0
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: processing ? 250 : 300, height: 60)
                    .foregroundColor(completed ? .red : .green)
                
                if !processing {
                    
                    Text("Submit")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .transition(.move(edge: .top))
                }
                
                if processing && !completed {
                    
                    HStack {
                        
                        Circle()
                            .trim(from: 0, to: 0.9)
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 30, height: 30)
                            .rotationEffect(Angle(degrees: loading ? 360 : 0))
                            .animation(Animation.easeOut.repeatForever(autoreverses: false))
                        
                        Text("Processing")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .foregroundColor(.white)
                    }
                    .transition(.opacity)
                    .onAppear() {
                        self.startProcessing()
                    }
                }
                
                if completed {
                    
                    Text("Done")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .onAppear() {
                            self.endProcessing()
                        }
                }
            }
            .animation(.spring())
            .onTapGesture {
                self.processing.toggle()
            }
        }
    }
    
    private func startProcessing() {
        self.loading = true
        self.isProgressLoading = false
        
        // Simulate an operation by using DispatchQueue.main.asyncAfter
        // In a real world project, you will perform a task here.
        // When the task finishes, you set the completed status to true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.completed = true
        }
    }
    
    private func endProcessing() {
        // Reset the button's state
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.processing = false
            self.completed = false
            self.loading = false
            self.isProgressLoading = true
            self.isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
