//
//  LotteryViewController.swift
//  Lottery
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Combine

final class LotteryViewController: UIViewController {
    
    private let viewModel = LotteryViewModel()
    private var anyCancellable = [AnyCancellable]()

    @IBOutlet var lotteryNumberLabels: [UILabel]!
    @IBOutlet weak var bonusLotteryNumberLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    private let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        bindingViewModel()
        request()
    }
    
    func bindingViewModel() {
        
        viewModel.$lottery
            .sink { lottery in
                self.updateLabels(with: lottery)
            }.store(in: &anyCancellable)
        
        viewModel.$session
            .map { String($0) + "회차" }
            .sink { session in
                self.textField.text = session
                self.request()
            }
            .store(in: &anyCancellable)
    }
    
    func request() {
        viewModel.request()
    }
}

extension LotteryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.session = viewModel.titles[row]
    }
}

extension LotteryViewController {
    
    func updateLabels(with lottery: Lottery?) {
        guard let lottery else { return }
        self.lotteryNumberLabels[0].text = String(lottery.drwtNo1)
        self.lotteryNumberLabels[1].text = String(lottery.drwtNo2)
        self.lotteryNumberLabels[2].text = String(lottery.drwtNo3)
        self.lotteryNumberLabels[3].text = String(lottery.drwtNo4)
        self.lotteryNumberLabels[4].text = String(lottery.drwtNo5)
        self.lotteryNumberLabels[5].text = String(lottery.drwtNo6)
        self.bonusLotteryNumberLabel.text = String(lottery.bnusNo)
    }
    
    private func configureViews() {
        picker.dataSource = self
        picker.delegate = self
        
        textField.inputView = picker
    }
}

