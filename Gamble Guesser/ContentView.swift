import SwiftUI

struct ContentView: View {
    @State private var targetNumber = 0
    @State private var userGuess = ""
    @State private var feedback = "Choose a difficulty to start 🎲"
    @State private var attempts = 0
    @State private var maxAttempts = 0
    @State private var gameActive = false
    @State private var showEndGame = false
    @State private var didWin = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎲 Gamble Guesser")
                .font(.title)
                .bold()
            
            if !gameActive {
                Text("Select a difficulty to begin")
                    .padding()
                
                HStack {
                    Button("Easy") { startGame(range: 1...50, attempts: 10) }
                        .buttonStyle(DifficultyButton(color: .green))
                    
                    Button("Medium") { startGame(range: 1...100, attempts: 7) }
                        .buttonStyle(DifficultyButton(color: .orange))
                    
                    Button("Hard") { startGame(range: 1...500, attempts: 5) }
                        .buttonStyle(DifficultyButton(color: .red))
                }
            } else {
                Text(feedback)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                TextField("Enter your guess", text: $userGuess)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 40)
                
                Button(action: checkGuess) {
                    Text("Check Guess")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                
                Text("Attempts left: \(maxAttempts - attempts)")
                    .font(.headline)
                    .padding(.top, 10)
            }
        }
        .padding()
        .alert(isPresented: $showEndGame) {
            Alert(
                title: Text(didWin ? "🎉 You Win!" : "💀 Game Over"),
                message: Text(didWin ? "Nice job! The number was \(targetNumber)." : "Out of attempts! The number was \(targetNumber)."),
                dismissButton: .default(Text("Play Again"), action: resetGame)
            )
        }
    }
    
    // MARK: - Game Logic
    func startGame(range: ClosedRange<Int>, attempts: Int) {
        targetNumber = Int.random(in: range)
        maxAttempts = attempts
        self.attempts = 0
        userGuess = ""
        feedback = "Guess a number between \(range.lowerBound) and \(range.upperBound) 🎯"
        gameActive = true
    }
    
    func checkGuess() {
        guard let guess = Int(userGuess) else {
            feedback = "⚠️ Enter a valid number!"
            return
        }
        
        attempts += 1
        
        if guess < targetNumber {
            feedback = "📉 Too low!"
        } else if guess > targetNumber {
            feedback = "📈 Too high!"
        } else {
            didWin = true
            showEndGame = true
            gameActive = false
            return
        }
        
        if attempts >= maxAttempts {
            didWin = false
            showEndGame = true
            gameActive = false
        }
    }
    
    func resetGame() {
        gameActive = false
        feedback = "Choose a difficulty to start 🎲"
        userGuess = ""
    }
}

// MARK: - Button Style
struct DifficultyButton: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView()
}
