import SwiftUI

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        //번들에서 파일 경로를 읽어옴
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // 파일 경로에서 데이터를 찾음
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        //JSON 디코더 인스턴스를 생성
        let decoder = JSONDecoder()
        
        // 날짜 표시 가공을 위해 DateFormatter()를 불러옴
        let formatter = DateFormatter()
        // 날짜 표시 형식을 연-월-일로 설정
        // mm은 제로 패딩된 분(시분초 중 분), MM은 제로 패딩된 월(연월일 중 월)을 의미한다.
        formatter.dateFormat = "y-MM-dd"
        //JSON 디코더에 날짜 표시 형식을 지정한다.
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
