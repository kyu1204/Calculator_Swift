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
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    
    var numberString: String = "0" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                if let intString = Decimal(string: self.numberString) {
                    if intString >= 1 {
                        self.resultLabel.text = self.numberFormatter.string(for: intString)
                    }
                    else if intString <= -1 {
                        self.resultLabel.text = self.numberFormatter.string(for: intString)
                    }
                    else {
                        self.resultLabel.text = self.numberString
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 10
        
        for numButton in numberButtonList {
            numButton.addTarget(self, action: #selector(onNumberButtonClick(sender:)), for: .touchUpInside)
        }
        
    }
    
    func historyAppend(data: String, flag: String) {
        switch flag {
        case "oper":
            history.append(data)
        default:
            if let intString = Double(data) {
                history.append(self.numberFormatter.string(from: NSNumber(value: intString))!)
            }
        }
    }
    
    @objc fileprivate func onNumberButtonClick(sender: UIButton) {
        if resetFlag {
            self.numberString.removeAll()
            buttonCount = 0
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
        if self.numberString.contains("-") {
            self.numberString.remove(at: self.numberString.startIndex)
        }
        else {
            self.numberString = "-" + self.numberString
        }
    }
    
    @IBAction func onPercentButtonClick(_ sender: Any) {
        if var intString = Decimal(string: self.numberString) {
            intString /= 100
            self.numberString = "\(intString)"
        }
    }
    
    @IBAction func onDotButtonClick(_ sender: Any) {
        if !self.numberString.contains(".") && !self.resultLabel.text!.contains(".") {
            self.numberString.append(".")
        }
    }
    
    @IBAction func onEqualButtonClick(_ sender: Any) {
        historyAppend(data: self.numberString, flag: "num")
        switch operateData {
        case "+":
            if let intString = Double(self.numberString) {
                operateData = "+"
                if resetFlag{
                    firstNum += lastNum
                    historyAppend(data: "+", flag: "oper")
                    historyAppend(data: String(lastNum), flag: "num")
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
                    historyAppend(data: "-", flag: "oper")
                    historyAppend(data: String(lastNum), flag: "num")
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
                    historyAppend(data: "*", flag: "oper")
                    historyAppend(data: String(lastNum), flag: "num")
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
                    historyAppend(data: "/", flag: "oper")
                    historyAppend(data: String(lastNum), flag: "num")
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
        historyAppend(data: "=", flag: "oper")
        historyAppend(data: "\(self.firstNum)", flag: "num")
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
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    operation()
                }
            }
        }
        historyAppend(data: numberString, flag: "num")
        historyAppend(data: "+", flag: "oper")
        operateData = "+"
        resetFlag = true
    }
    
    @IBAction func onMinusButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
                if firstNum == 0 {
                    firstNum = lastNum
                }
                else {
                    operation()
                }
            }
        }
        historyAppend(data: numberString, flag: "num")
        historyAppend(data: "-", flag: "oper")
        operateData = "-"
        resetFlag = true
    }
    
    @IBAction func onMutipleButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
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
        historyAppend(data: numberString, flag: "num")
        historyAppend(data: "*", flag: "oper")
        operateData = "*"
        resetFlag = true
    }
    
    @IBAction func onDivisionButtonClick(_ sender: Any) {
        if !self.resetFlag {
            if let intString = Double(self.numberString) {
                lastNum = intString
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
        historyAppend(data: numberString, flag: "num")
        historyAppend(data: "/", flag: "oper")
        operateData = "/"
        resetFlag = true
    }
    
}
