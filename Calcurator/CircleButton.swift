//
//  CircleButton.swift
//  Calcurator
//
//  Created by 김민규 on 2021/09/21.
//

import Foundation
import UIKit

@IBDesignable
class CircleButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = 0 > cornerRadius
        }
    }
}
