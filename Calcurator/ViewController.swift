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
    @IBOutlet weak var dotButton: CircleButton!
    @IBOutlet weak var plusButton: CircleButton!
    @IBOutlet weak var minusButton: CircleButton!
    @IBOutlet weak var mutipleButton: CircleButton!
    @IBOutlet weak var divisonButton: CircleButton!
    @IBOutlet weak var equalButton: CircleButton!
    @IBOutlet weak var historyButton: UIButton!
    
    var buttonCount: Int = 0
    var firstNum: Double = 0.0
    var lastNum: Double = 0.0
    var tmpNum: Double = 0.0
    var operateData: String = ""
    var resetFlag: Bool = false
    var history: String = ""
    var historyList: Array<String> = []
    
    
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
        if resetFlag {
            self.numberString.removeAll()
            resetFlag = false
        }
        if buttonCount < 9 {
            guard let inputString = sender.titleLabel?.text else { return }
            
            let clickNumber = inputString.trimmingCharacters(in: .whitespaces)
            
            if clickNumber == "0" {
                if numberString != "0" && numberString != "" {
                    numberString.append(clickNumber)
                    buttonCount += 1
                }
                else {
                    numberString = clickNumber
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "historySegue" == id {
            if let resultView = segue.destination as? HistoryView {
                // 데이터 셋팅
                resultView.historyList = self.historyList
            }
        }
    }
    
    @IBAction func onHistoryButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "historySegue", sender: nil)
    }
    
    
    @IBAction func onClearButton(_ sender: Any) {
        numberString.removeAll()
        operateData = ""
        resultLabel.text = "0"
        buttonCount = 0
        firstNum = 0.0
        
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
    
    @IBAction func onEqualButtonClick(_ sender: Any) {
        history.append(numberString)
        switch operateData {
        case "+":
            if let intString = Double(self.numberString) {
                operateData = "+"
                if resetFlag{
                    firstNum += lastNum
                    history.append("+")
                    history.append(String(lastNum))
                }
                else {
                    lastNum = intString
                    firstNum += lastNum
                    
                }
                DispatchQueue.main.async {
                    self.numberString = "\(self.firstNum)"
                    self.resetFlag = true
                }
            }
        case "-":
            if let intString = Double(self.numberString) {
                operateData = "-"
                if resetFlag{
                    firstNum -= lastNum
                    history.append("-")
                    history.append(String(lastNum))
                }
                else {
                    lastNum = intString
                    firstNum -= lastNum
                }
                DispatchQueue.main.async {
                    self.numberString = "\(self.firstNum)"
                    self.resetFlag = true
                }
            }
        case "*":
            if let intString = Double(self.numberString) {
                operateData = "*"
                if resetFlag{
                    firstNum *= lastNum
                    history.append("*")
                    history.append(String(lastNum))
                }
                else {
                    if tmpNum != 0 {
                        lastNum = intString
                        tmpNum *= lastNum
                        firstNum += tmpNum
                        tmpNum = 0
                    }
                    else {
                        lastNum = intString
                        firstNum *= lastNum
                    }
                }
                DispatchQueue.main.async {
                    self.numberString = "\(self.firstNum)"
                    self.resetFlag = true
                }
            }
        case "/":
            if let intString = Double(self.numberString) {
                operateData = "/"
                if resetFlag{
                    firstNum /= lastNum
                    history.append("/")
                    history.append(String(lastNum))
                    DispatchQueue.main.async {
                        self.numberString = "\(self.firstNum)"
                        self.resetFlag = true
                    }
                }
                else {
                    if intString == 0 {
                        DispatchQueue.main.async {
                            self.resultLabel.text = "오류"
                            self.firstNum = 0
                            self.lastNum = 0
                            self.tmpNum = 0
                            self.resetFlag = true
                        }
                    }
                    else {
                        if tmpNum != 0 {
                            lastNum = intString
                            tmpNum /= lastNum
                            firstNum += tmpNum
                            tmpNum = 0
                        }
                        else {
                            lastNum = intString
                            firstNum /= lastNum
                        }
                        DispatchQueue.main.async {
                            self.numberString = "\(self.firstNum)"
                            self.resetFlag = true
                        }
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.resetFlag = true
            }
        }
        history.append("=")
        history.append("\(self.firstNum)")
        historyList.append(history)
        history = ""
    }
    
    func operation() {
        switch operateData {
        case "+":
            if let intString = Double(self.numberString) {
                if resetFlag{
                    firstNum += lastNum
                }
                else {
                    lastNum = intString
                    firstNum += lastNum
                    
                }
                DispatchQueue.main.async {
                    self.lastNum = self.firstNum
                    self.numberString = "\(self.firstNum)"
                }
            }
        case "-":
            if let intString = Double(self.numberString) {
                if resetFlag{
                    firstNum -= lastNum
                }
                else {
                    lastNum = intString
                    firstNum -= lastNum
                }
                DispatchQueue.main.async {
                    self.lastNum = self.firstNum
                    self.numberString = "\(self.firstNum)"
                }
            }
        case "*":
            if let intString = Double(self.numberString) {
                if resetFlag{
                    firstNum *= lastNum
                }
                else {
                    if tmpNum != 0 {
                        lastNum = intString
                        tmpNum *= lastNum
                        firstNum += tmpNum
                        tmpNum = 0
                    }
                    else {
                        lastNum = intString
                        firstNum *= lastNum
                    }
                }
                DispatchQueue.main.async {
                    self.lastNum = self.firstNum
                    self.numberString = "\(self.firstNum)"
                }
            }
        case "/":
            if let intString = Double(self.numberString) {
                if resetFlag{
                    firstNum /= lastNum
                    DispatchQueue.main.async {
                        self.lastNum = self.firstNum
                        self.numberString = "\(self.firstNum)"
                    }
                }
                else {
                    if intString == 0 {
                        DispatchQueue.main.async {
                            self.resultLabel.text = "오류"
                            self.firstNum = 0
                            self.lastNum = 0
                            self.tmpNum = 0
                            self.resetFlag = true
                        }
                    }
                    else {
                        if tmpNum != 0 {
                            lastNum = intString
                            tmpNum /= lastNum
                            firstNum += tmpNum
                            tmpNum = 0
                        }
                        else {
                            lastNum = intString
                            firstNum /= lastNum
                        }
                        DispatchQueue.main.async {
                            self.lastNum = self.firstNum
                            self.numberString = "\(self.firstNum)"
                        }
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.resultLabel.text = "오류"
            }
        }
    }
    
    @IBAction func onPlusButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
                history.append(numberString)
                history.append("+")
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    operation()
                }
            }
        }
        operateData = "+"
        resetFlag = true
    }
    
    @IBAction func onMinusButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
                history.append(numberString)
                history.append("-")
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    operation()
                }
            }
        }
        operateData = "-"
        resetFlag = true
    }
    
    @IBAction func onMutipleButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
                history.append(numberString)
                history.append("*")
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    if operateData == "+" {
                        tmpNum = lastNum
                    }
                    else if operateData == "-" {
                        tmpNum = lastNum * -1
                    }
                    else {
                        operation()
                    }
                }
            }
        }
        operateData = "*"
        resetFlag = true
    }
    
    @IBAction func onDivisionButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
                history.append(numberString)
                history.append("/")
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    if operateData == "+" {
                        tmpNum = lastNum
                    }
                    else if operateData == "-" {
                        tmpNum = lastNum * -1
                    }
                    else {
                        operation()
                    }
                }
            }
        }
        operateData = "/"
        resetFlag = true
    }
    
}
