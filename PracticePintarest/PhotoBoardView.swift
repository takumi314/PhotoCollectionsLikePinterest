//
//  PhotoBoardView.swift
//  PracticePinterest
//
//  Created by NishiokaKohei on 2016/11/19.
//  Copyright © 2016年 Kohey. All rights reserved.
//

import UIKit

@IBDesignable
class PhotoBoardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
