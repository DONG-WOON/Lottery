//
//  LotteryViewModel.swift
//  Lottery
//
//  Created by 서동운 on 9/13/23.
//

import Foundation
import Alamofire

class LotteryViewModel {
    
    static let sessions = (1...1079).reversed()
    
    @Published var lottery: Lottery?
    @Published var session: String = String(sessions.first!)
    
    var numberOfRows: Int {
        return LotteryViewModel.sessions.count
    }
    
    var titles: [String] {
        return LotteryViewModel.sessions.map { String($0) }
    }
    
    func request() {
        
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(session)"
        
        AF.request(url).responseDecodable(of: Lottery.self) { response in
            switch response.result {
            case .success(let lottery):
                self.lottery = lottery
            case .failure(let error):
                print(error)
            }
        }
    }
}
