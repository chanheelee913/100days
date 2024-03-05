//
//  ContentView.swift
//  WordScramble
//
//  Created by 이찬희 on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()   //이미 사용한 단어를 저장하는 배열
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) {word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                Section {
                    Text("score: \(score)")
                }
                
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Reset") {
                    startGame()
                }
            }
        }
        
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) { } message: {
            Text(errorMessage)
        }
    }
    
    
    func addNewWord() {
        //입력값을 소문자로 변환하고 앞뒤 공백을 자른다.
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 3자 이상인지 체크
        guard isValidLength(word: answer) else {
            wordError(title: "Word too short", message: "3글자 이상")
            return
        }
        
        // 처음 제공된 단어와 같은 단어인지 체크
        guard isSame(word: answer) else {
            wordError(title: "Word is same", message: "처음 제공된 단어와 같은 단어입니다")
            return
        }
        
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        //사용한 단어 배열 0번 인덱스에 입력값을 저장한다. 이후 newWord를 빈 값으로 초기화한다.
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        // 점수를 추가
        addScore(word: answer)
        // 새로 입력할 단어를 초기화
        newWord = ""
    }
    
    func startGame() {
        //1. app bundle의 start.txt의 URL을 찾음
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //2. start.txt의 url을 String형으로 가져옴
            if let startWords = try? String(contentsOf: startWordsURL) {
                //3. 모든 문자열을 String형 배열로 변환
                let allWords = startWords.components(separatedBy: "\n")
                
                //4. 랜덤하게 문자 하나를 지정하여 루트로 설정
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // 점수를 초기화
                score = 0
                
                //모든 단계가 끝났으면 함수를 빠져나감
                return
            }
        }
        
        //위 단계에 문제가 생기면 fatalError 함수가 호출이 됨
        fatalError("Could not load start.txt from bundle")
    }
    
    // 3글자 이상인지 체크
    func isValidLength(word: String) -> Bool {
        (word.count >= 3)
    }
    
    // 시작 단어와 다른 단어인지 체크
    func isSame(word: String) -> Bool {
        !(rootWord == word)
    }
    
    //이미 사용된 단어인지 체크
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // 주어진 단어로부터 만들어낼 수 있는지 (없는 알파벳으로 단어를 만들었는지 체크)
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    // 실제 단어인지 체크하는 메소드
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location:0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in:word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    //에러가 났을 때 타이틀과 메시지를 설정하고 알림을 띄운다
    func wordError(title:String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
   
    
    func addScore(word: String) {
        score += word.count * 10
    }
}



#Preview {
    ContentView()
}
