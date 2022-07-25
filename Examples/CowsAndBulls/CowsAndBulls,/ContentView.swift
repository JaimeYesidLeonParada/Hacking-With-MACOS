//
//  ContentView.swift
//  CowsAndBulls,
//
//  Created by Jaime Yesid Leon Parada on 11/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var guesses = [String]()
    @State private var guess = ""
    @State private var answer = ""
    @State private var isGameOver = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                TextField("Enter a guess..", text: $guess)
                    .onSubmit(submitGuess)
                
                Button("Go", action: submitGuess)
            }
            .padding()
            
            List(guesses, id:\.self){ guess in
                HStack{
                    Text(guess)
                    Spacer()
                    Text(result(for: guess))
                }
            }
            .listStyle(.sidebar)
            
        }
        .frame(width: 250)
        .frame(minHeight: 300)
        .navigationTitle("Cows and Bulls")
        .onAppear(perform: startNewGame)
        .touchBar{
            HStack{
                Text("Guesses: \(guesses.count)").touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
        .alert("You Win!", isPresented: $isGameOver){
            Button("OK", action: startNewGame)
        } message: {
            Text("Congratulations! Click OK to play again")
        }
    }
    
    
    func submitGuess(){
        //guard Set(guess).count == 4 else { return }
        //guard guess.count == 4 else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        withAnimation{
            guesses.insert(guess, at: 0)
        }
        
        // did the player win?
        if result(for: guess).contains("4b") {
            isGameOver = true
        }
        
        //clear their guess string
        guess = ""
    }

    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index]{
                bulls += 1
            } else if answerLetters.contains(letter){
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }

    func startNewGame(){
        guess = ""
        answer = ""
        guesses.removeAll()
        
        let numbers = (0...9).shuffled()
        
        for i in 0..<4 {
            answer.append(String(numbers[i]))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
