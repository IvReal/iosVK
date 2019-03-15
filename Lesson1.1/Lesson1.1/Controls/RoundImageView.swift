//  RoundImageView.swift
//  Lesson1.1
//  Created by Iv on 11/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

/*
 Idea:
 Подкладывать слой с тенью под замаскированный овалом основной слой ImageView,
 добавляя его в superlayer перед основным слоем
*/
class RoundImageView: UIImageView {

    @IBInspectable var NeedShadow: Bool = true
    @IBInspectable var ShadowColor: UIColor? = .black
    @IBInspectable var ShadowOpacity: Float = 0.5
    @IBInspectable var ShadowOffset: CGSize = .zero
    @IBInspectable var ShadowRadius: Float = 3.0
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // oval path
        let roundPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))

        // mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer

        // shadow layer
        shadowLayer?.removeFromSuperlayer()
        // superlayer must exist to make shadow in my realization
        guard let superlayer = layer.superlayer else {
            return
        }
        if NeedShadow {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = roundPath.cgPath
            shadowLayer.frame = self.frame
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = ShadowColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = ShadowOffset // .zero
            shadowLayer.shadowOpacity = ShadowOpacity
            shadowLayer.shadowRadius = CGFloat(ShadowRadius)
            
            superlayer.insertSublayer(shadowLayer, below: layer)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
