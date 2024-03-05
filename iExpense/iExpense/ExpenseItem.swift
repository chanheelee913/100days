// expense를 저장하기 위한 구조체와 클래스를 정의함

import Foundation
import Observation

// 저장되는 아이템의 항목을 구조체로 정의함.
// 이 구조체는 유니크하고(Identifiable), 다른 타입으로 변환(Codable)될 수 있음.
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    //amount의 통화 단위를 저장
    let code: String
}

// 아이템 구조체를 저장할 클래스. 클래스에 ExpenseItem 배열이 생성됨.
// 배열의 변화에 따라 SwiftUI가 뷰를 자동으로 업데이트 해야하기 때문에,
// @Observable 매크로를 사용함

@Observable
class Expenses {
    //UserDefaults에 저장하기 위해 키를 매개변수로 받아옴
    let key: String
    
    //Expenses 인스턴스 생성될 때 초기화 구문
    init(key: String) {
        self.key = key
        // UserDefaults에 이미 저장된 데이터가 있는 경우
        if let savedItems = UserDefaults.standard.data(forKey: key) {
            // savedItems에 저장되어 있는 JSON 파일을 디코딩 시도함
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                //savedItems에 있는 데이터를 디코딩하여 items에 할당
                items = decodedItems
                return
            }
        }
        // 없는 경우 새로운 items 배열을 생성
        items = []
    }
    
    //items 선언
    var items = [ExpenseItem]() {
        //값이 할당되고 나서 실행.
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: key)
            }    //if let
        }    //didSet
    }
    
    
    
    
    
}

