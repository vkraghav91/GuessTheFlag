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
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var message = ""
    
    var body: some View{
        ZStack{
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of :")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<4){ number in
                    Button(action: {
                        self.flagTapped(number)
                    }){
                      //  flagImage(imageName: countries[number])
                        FlagImage(imageName: countries[number])

                    }
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
        if number == correctAnswer{
            scoreTitle = "Correct Answer"
            score += 1
            self.message = "Your score is \(score)"
        } else{
            scoreTitle = "Wrong Answer"
            score -= 1
            self.message = "That is the flag of \(countries[number]) \n Your score is \(score)"
        }
        showingScore = true
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
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
