//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by 이찬희 on 11/27/23.
//

import SwiftUI

struct ContentView: View {
    
    //가위바위보 배열
    @State private var rps = ["Rock", "Paper", "Scissors"]
    //alert에 표시할 문구를 저장
    @State private var alertTitle = ""
    //정답 alert를 표시
    @State private var showAnswerAlert = false
    // 이겨야 하는지? 져야 하는지?
    @State private var isWin = Bool.random()
    //시스템의 선택
    @State private var systemSelected = Int.random(in: 0...2)
    //현재 스테이지
    @State private var stage = 1
    //점수를 저장
    @State private var score = 0
    //게임 끝났는지 여부
    @State private var isGameEnd = false
    
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
            
            ForEach(0..<3) { number in
                Button {
                    buttonTapped(number: number)
                } label: {
                    Text("A")
                }
            }
                
        }
        .alert(alertTitle, isPresented: $showAnswerAlert) {
            Button("Continue", action: {})
        }
        //게임 종료 알림
        .alert("Game End, Score: \(score)", isPresented: $isGameEnd) {
            Button("Restart", action: reset)
        }
        

    }
    
    func buttonTapped(number: Int) {
        if isWin {
            alertTitle = "맞았습니다!"
            score += 1
        } else {
            alertTitle = "틀렸습니다!"
            score -= 1
        }
        stage+=1
        
        //결과 alert를 표시하도록 상태를 변환
        showAnswerAlert = true
    }
    
    func askQuestion() {
        
        //Int.random(in: 0...2)
    }
    
    func reset() {
        //배열을 섞고 진행 상황을 초기화함
        rps.shuffle()
        score = 0
        stage = 1
    }
}

#Preview {
    ContentView()
}
