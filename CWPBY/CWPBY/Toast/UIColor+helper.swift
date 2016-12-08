//
//  UIColor+helper.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/12/1.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hex rgbHexValue: UInt, alpha: CGFloat) {
    self.init(red: ((CGFloat)((rgbHexValue & 0xFF0000) >> 16))/255.0,
              green: ((CGFloat)((rgbHexValue & 0xFF00) >> 8))/255.0,
              blue: ((CGFloat)(rgbHexValue & 0xFF))/255.0,
              alpha: alpha)
  }

  convenience init(hex rgbHexValue: UInt) {
    self.init(hex: rgbHexValue, alpha: 1.0)
  }

}
