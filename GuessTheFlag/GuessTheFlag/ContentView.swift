//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 이찬희 on 11/7/23.
//

import SwiftUI

// 깃발 이미지 커스텀 뷰
struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

//커스텀 수정자
struct BlueLargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle
                .weight(.bold))
            .foregroundStyle(.blue)
    }
}

//커스텀 수정자를 래핑
extension View {
    func blueLargeTitle() -> some View {
        modifier(BlueLargeTitle())
    }
}


struct ContentView: View {
    
    //국기들의 배열
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)

    //alert를 표시할 프로퍼티
    @State private var showingScore = false
    // alert 안에 저장할 타이틀
    @State private var scoreTitle = ""
    
    //점수를 저장할 프로퍼티
    @State private var score = 0
    
    //8문제 중 현재 몇 스테이지인지?
    @State private var stage = 1
    //게임이 끝나는지를 체크
    @State private var isGameEnd = false
    
    //어떤 버튼이 선택되었는지를 추적하는 프로퍼티
    @State private var selectedButton = 0
    
    
    var body: some View {
        
        ZStack {
            //배경 설정
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            //외부 VStack
            VStack {
                Text("Guess the Flag( \(stage) / 8 )")
                    .blueLargeTitle()
                
                //내부 VStack
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                            
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            
                    }
                    
                    
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(country: countries[number])
                            }
                            
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }
            .padding()
        }
        .alert(scoreTitle,isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
                
        }
        .alert("Game End, Total Score: \(score)", isPresented: $isGameEnd) {
            Button("Restart", action: reset)
        }
    }
        
    // 정답과 오답을 처리하는 부분, 주요 게임 로직
    func flagTapped(_ number:Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 10 //10점 추가
        } else {
            scoreTitle = "Wrong! it's \(countries[number])"
            score -= 1
        }
        
        // alert를 표시하도록 프로퍼티의 값을 변경
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if stage>=8 {
            isGameEnd = true
        } else {
            stage += 1
            
        }
    }
    
    //게임을 리셋함
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        stage = 1
        score = 0
    }
}

#Preview {
    ContentView()
}
