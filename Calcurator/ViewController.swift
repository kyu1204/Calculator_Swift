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
    @IBOutlet weak var percentButton: CircleButton!
    @IBOutlet weak var dotButtonClick: CircleButton!
    
    var buttonCount: Int = 0
    
    var numberString: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                if let intString = Double(self.numberString) {
                    if intString >= 1 {
                        self.resultLabel.text = numberFormatter.string(from: NSNumber(value: intString))
                    }
                    else if intString <= -1 {
                        self.resultLabel.text = numberFormatter.string(from: NSNumber(value: intString))
                    }
                    else if intString == 0 {
                        self.resultLabel.text = numberFormatter.string(from: NSNumber(value: intString))
                    }
                    else {
                        self.resultLabel.text = "\(intString)"
                    }
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
        if buttonCount < 9{
            guard let inputString = sender.titleLabel?.text else { return }
            
            let clickNumber = inputString.trimmingCharacters(in: .whitespaces)
            
            if clickNumber == "0" {
                if numberString != "0" && numberString != "" {
                    numberString.append(clickNumber)
                    buttonCount += 1
                }
            }
            else {
                numberString.append(clickNumber)
                buttonCount += 1
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
        buttonCount = 0
        
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
        if var intString = Float(self.numberString) {
            intString *= -1
            self.numberString = String(intString)
        }
    }
    
    @IBAction func onPercentButtonClick(_ sender: Any) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if var intString = Decimal(string: self.numberString) {
            intString /= 100
            self.numberString = "\(intString)"
        }
    }
    
    @IBAction func onDotButtonClick(_ sender: Any) {
        if !self.numberString.contains(".") {
            self.numberString.append(".")
            
            DispatchQueue.main.async {
                self.resultLabel.text = self.numberString
            }
        }
    }
    
}

