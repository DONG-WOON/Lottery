//
//  LotteryViewController.swift
//  Lottery
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class LotteryViewController: UIViewController {

    @IBOutlet var lotteryNumberLabels: [UILabel]!
    @IBOutlet weak var bonusLotteryNumberLabel: UILabel!
    
    private let picker = UIPickerView()
    
    var sessions: [Int] = (1...1079).reversed()
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        textField.inputView = picker
        request(session: sessions.first!)
        textField.text = "\(sessions.first!)회차"
        // Do any additional setup after loading the view.
    }

    func request(session: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(session)"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var lottery = [Int]()
                
                (1...6).forEach { i in
                    lottery.append(json["drwtNo\(i)"].intValue)
                }
                lottery.append(json["bnusNo"].intValue)
                
                self.updateLotteryLabel(with: lottery)
            case .failure(let error):
                print(error)
            }
        }
        //request
        /*
         {
             "totSellamnt": 3681782000,
             "returnValue": "success",
             "drwNoDate": "2002-12-07",
             "firstWinamnt": 0,
             "drwtNo6": 40,
             "drwtNo4": 33,
             "firstPrzwnerCo": 0,
             "drwtNo5": 37,
             "bnusNo": 16,
             "firstAccumamnt": 863604600,
             "drwNo": 1,
             "drwtNo2": 23,
             "drwtNo3": 29,
             "drwtNo1": 10
         }
         */
    }
    
    private func updateLotteryLabel(with data: [Int]) {
        for i in 0..<6 {
            lotteryNumberLabels[i].text = "\(data[i])"
        }
        bonusLotteryNumberLabel.text = "\(data[6])"
    }
}

extension LotteryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sessions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(sessions[row])회차"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        request(session: sessions[row])
        textField.text = "\(sessions[row])회차"
    }
}

