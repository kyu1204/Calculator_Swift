//
//  ViewController.swift
//  Calcurator
//
//  Created by 김민규 on 2021/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var numberButtonList: [CircleButton]!
    @IBOutlet weak var clearButton: CircleButton!
    @IBOutlet weak var negativeButton: CircleButton!
    
    var numberString: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let intString = Int(self.numberString) {
                    self.resultLabel.text = numberFormatter.string(from: NSNumber(value: intString))
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for numButton in numberButtonList {
            numButton.addTarget(self, action: #selector(onNumberButtonClick(sender:)), for: .touchUpInside)
        }
        
    }
    
    @objc fileprivate func onNumberButtonClick(sender: UIButton) {
        print(numberString)
        if numberString.count < 9{
            guard let inputString = sender.titleLabel?.text else { return }
            
            let clickNumber = inputString.trimmingCharacters(in: .whitespaces)
            
            if clickNumber == "0" {
                if resultLabel.text != "0" {
                    numberString.append(clickNumber)
                }
            }
            else {
                numberString.append(clickNumber)
            }
            
            if clearButton.titleLabel?.text == "AC" {
                UIView.setAnimationsEnabled(false)
                clearButton.setTitle("C", for: .normal)
                clearButton.layoutIfNeeded()
                UIView.setAnimationsEnabled(true)
            }
            
        }
    }
    
    @IBAction func onCluearButtonClick(_ sender: Any) {
        numberString.removeAll()
        resultLabel.text = "0"
        
        if clearButton.titleLabel?.text == "C" {
            UIView.setAnimationsEnabled(false)
            clearButton.setTitle("AC", for: .normal)
            clearButton.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
        }
    }
    @IBAction func onNegativeButtonClick(_ sender: Any) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if var intString = Int(self.numberString) {
            intString *= -1
            self.resultLabel.text = numberFormatter.string(from: NSNumber(value: intString))
            self.numberString = String(intString)
        }
    }
    
}

