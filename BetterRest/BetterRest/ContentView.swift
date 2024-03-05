//
//  ContentView.swift
//  BetterRest
//
//  Created by 이찬희 on 12/5/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    // 언제 일어나야 하는지?
    @State private var wakeUp = defaultWakeTime
    // 잠을 자는 시간은 얼마나 되는지?
    @State private var sleepAmount = 8.0
    // 하루에 커피를 몇 잔 마시는지?
    @State private var coffeeAmount = 1
    
    // alert 타이틀, 메시지, 표시 프로퍼티
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime :Date {
        //DateComponent 인스턴스 생성
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                // 언제 일어나고 싶은지
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                //얼마나 자고 싶은지
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                // 하루에 커피를 몇 잔 마시는지
                VStack(alignment: .leading, spacing:0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper("^[\(coffeeAmount) cup](inflect: true)" , value: $coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
                
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            // ML 모델을 로드
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // 시,분만 가져오기 위해 dateComponents를 가져옴
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour+minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            // alert의 문구를 설정
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
            
        } catch {
            // 오뷰 발생 시 실행되는 구문
            alertTitle = "Error"
            alertMessage = "Sorry"
        }
        
        //오류 여부에 관계없이 alert를 보여준다.
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
