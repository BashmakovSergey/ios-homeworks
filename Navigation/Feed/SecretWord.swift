import Foundation

struct SecretWord {
    let secretWord: String
}

final class SecretWords {
    
    private let secretWords = [
        SecretWord(secretWord: "Dune"),
        SecretWord(secretWord: "Bad"),
        SecretWord(secretWord: "WarHammer"),
        SecretWord(secretWord: "Bolter")
        ]
    
    func todayIsSecretWord() -> String {
        guard let randomElement = secretWords.randomElement() else {
            return "error"
        }
        return randomElement.secretWord
    }
    
}
