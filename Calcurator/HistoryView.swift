//
//  HistoryView.swift
//  Calcurator
//
//  Created by 김민규 on 2021/09/23.
//

import Foundation
import UIKit

class HistoryView: UIViewController {
    
    @IBOutlet weak var historyTable: UITableView!
    
    var historyList: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTable.delegate = self
        self.historyTable.dataSource = self
    }
    
    
}

extension HistoryView: UITableViewDelegate {
    
}

extension HistoryView: UITableViewDataSource {
    
    // 테이블 뷰 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyList.count
    }
    
    // 각 셀에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath) as! MyTableCell
        
        cell.historyLabel.text = historyList[indexPath.row]
        
        return cell
    }
    
}
