//
//  RadiusShadowView.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/12/5.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import UIKit

//一个可视化的给UIView设置边界阴影的类，通过在Interface Builder中直接更改值实时查看效果

@IBDesignable
class RadiusShadowView: UIView {

    @IBInspectable
    var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowRadius).cgPath
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat = 0.0 {
        didSet {
            self.layer.shadowOpacity = Float(min(1.0, max(Double(shadowOpacity), 0.0)))
            setNeedsDisplay()
        }
    }

}
