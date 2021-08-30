//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Varun Kumar Raghav on 02/08/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Russia","UK","US"]
        .shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
    
    //properties for animations
    @State private var selectedNumber = 0
    @State private var isWrong = false
    @State private var isCorrect = false
    @State private var fadeOutOpacity = false

    
    var body: some View{
        ZStack{
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                Spacer()
                VStack{
                    Text("Tap the flag of :")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    Text(self.countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3){ number in
                    Button(action: {
                        withAnimation{
                            self.flagTapped(number)
                        }
                    }){
                          flagImage(imageName: countries[number])
                        //FlagImage(imageName: countries[number])
                    }.rotation3DEffect(
                        .degrees(self.isCorrect&&(self.selectedNumber==number) ? 360:0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                    .rotation3DEffect(
                        .degrees(self.isWrong&&(self.selectedNumber==number) ? 90:0),
                        axis: (x: 1.0, y: 0.0, z: 1.0)
                        )
                    .opacity(self.fadeOutOpacity && !(self.selectedNumber==number) ? 0.25:1)

                }
                
                Text("Your Current Score is: \(self.score)")
                    .foregroundColor(.white)
                    .fontWeight(.black)
                Spacer()
            }
        }.alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text(message), dismissButton: .default(Text("Continue")){
                self.askQuestion()
            })
        }
    }
    func flagTapped(_ number:Int){
        self.selectedNumber = number
        if number == correctAnswer{
            self.isCorrect = true
            self.fadeOutOpacity = true
            self.scoreTitle = "Correct Answer"
            self.score += 1
            self.message = "Your score is \(score)"
        } else{
            self.isWrong = true
            self.scoreTitle = "Wrong Answer"
            self.score -= 1
            self.message = "That is the flag of \(countries[number]) \n Your score is \(score)"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.showingScore = true
        }
    }
    func askQuestion(){
        self.countries.shuffle()
        self.correctAnswer = Int.random(in: 0..<3)
        self.fadeOutOpacity = false
        self.isWrong = false
        self.isCorrect = false
    }
}
// image view for flags
struct FlagImage: View{
    var imageName:String
    var body: some View{
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
extension View{
    func flagImage(imageName:String) -> some View {
        FlagImage(imageName: imageName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
