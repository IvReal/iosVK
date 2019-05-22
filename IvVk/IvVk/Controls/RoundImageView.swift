//  RoundImageView.swift
//  IvVk
//  Created by Iv on 11/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class RoundImageView: UIView {
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageView?.image = image
            updateView()
        }
    }
    @IBInspectable var NeedShadow: Bool = true
    @IBInspectable var ShadowColor: UIColor? = .black
    @IBInspectable var ShadowOpacity: Float = 1.0
    @IBInspectable var ShadowOffset: CGSize = .zero //CGSize(width: 3, height: 2)
    @IBInspectable var ShadowRadius: Float = 5.0
    
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        updateView()
    }
    
    private func updateView() {
        let roundPath = UIBezierPath(ovalIn: self.bounds)
        
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        if NeedShadow {
            self.layer.shadowColor = ShadowColor?.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = ShadowOffset
            self.layer.shadowRadius = CGFloat(ShadowRadius)
            self.layer.shadowPath = roundPath.cgPath
        } else {
            self.layer.shadowColor = nil
            self.layer.shadowOpacity = 0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 0
            self.layer.shadowPath = nil
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath

        imageView.backgroundColor = .white
        imageView.layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }

}

/*
 Idea:
 Подкладывать слой с тенью под замаскированный овалом основной слой ImageView,
 добавляя его в superlayer перед основным слоем
*/
class RoundImageView2: UIImageView {

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
