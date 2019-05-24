//  LikeControl.swift
//  IvVk
//  Created by Iv on 10/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class HeartButton: UIButton {
    
    @IBInspectable var color: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // calculate heart size and position
        let isHorizontalOrientation = rect.width >= rect.height
        let size = isHorizontalOrientation ? rect.height - 2 : rect.width - 2
        let x = isHorizontalOrientation ? rect.width / 2 - size / 2 : 1
        let y = isHorizontalOrientation ? 1 : rect.height / 2 - size / 2
        // draw heart image
        drawHeart(CGRect(x: x, y: y, width: size, height: size))
    }
    
    private func drawHeart(_ rect: CGRect) {
        let path = UIBezierPath()
        let arcRadius = sqrt(pow(rect.width * 0.4, 2) + pow(rect.height * 0.3, 2))/2
        // left arc
        path.addArc(withCenter: CGPoint(x: rect.origin.x + rect.width * 0.3,
                                        y: rect.origin.y + rect.height * 0.35),
                                        radius: arcRadius,
                                        startAngle: degToRad(135),
                                        endAngle: degToRad(315),
                                        clockwise: true)
        // center
        path.addLine(to: CGPoint(x: rect.origin.x + rect.width/2,
                                 y: rect.origin.y + rect.height * 0.2))
        // right arc
        path.addArc(withCenter: CGPoint(x: rect.origin.x + rect.width * 0.7,
                                        y: rect.origin.y + rect.height * 0.35),
                                        radius: arcRadius,
                                        startAngle: degToRad(225),
                                        endAngle: degToRad(45),
                                        clockwise: true)
        // right line
        path.addLine(to: CGPoint(x: rect.origin.x + rect.width * 0.5,
                                 y: rect.origin.y + rect.height * 0.95))
        // left line
        path.close()
        // color
        (color ?? tintColor).setFill()
        path.fill()
    }
    
    private func degToRad(_ degree: CGFloat) -> CGFloat {
        return CGFloat(degree) * .pi / 180
    }
}

class LikeControl: UIControl {
    
    private var stackView: UIStackView!
    private var buttonHeart: HeartButton!
    private var buttonCount: UIButton!
    private var countLike: Int = 0
    
    var tryChangeLike: (() -> (Int, Bool?))? = nil
    
    func setLikeStatus(_ count: Int, _ liked: Bool) {
        buttonHeart.color = liked ? .red : self.tintColor
        countLike = count
        self.updateControl()
        self.sendActions(for: .valueChanged)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        buttonHeart = HeartButton(type: .custom)
        buttonHeart.addTarget(self, action: #selector(updateLikeCount(_:)), for: .touchUpInside)
        
        buttonCount = UIButton(type: .system)
        buttonCount.addTarget(self, action: #selector(updateLikeCount(_:)), for: .touchUpInside)

        stackView = UIStackView(arrangedSubviews: [buttonHeart, buttonCount])
        self.addSubview(stackView)
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        updateControl()
    }
    
    private func updateControl() {
        buttonCount.setTitle("\(countLike)", for: .normal)
        buttonCount.setTitleColor(buttonHeart.color, for: .normal)
    }
    
    @objc private func updateLikeCount(_ sender: UIButton) {
        if let handler = tryChangeLike {
            let res = handler()
            if res.1 != nil {
                setLikeStatus(res.0, res.1!)
                animate(res.1 == true)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func animate(_ doneLike: Bool) {
        UIView.transition(with: self.buttonHeart,
                          duration: 1.5,
                          options: .transitionCrossDissolve,
                          animations: nil)
        UIView.transition(with: self.buttonCount,
                          duration: 1.5,
                          options: doneLike ? .transitionFlipFromRight : .transitionFlipFromLeft,
                          animations: nil)
    }
}
