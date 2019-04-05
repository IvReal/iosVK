//  LoadingControl.swift
//  Lesson1.1
//  Created by Iv on 20/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class LoadingControl: UIView {

    @IBInspectable var color: UIColor?  {
        didSet {
            for point in points {
                point.backgroundColor = color
            }
            setNeedsDisplay()
        }
    }

    private var points: [UIView] = []
    private var stackView: UIStackView!
    private var cloudLayer: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        for _ in (1...3) {
            let v = UIView()
            v.backgroundColor = color ?? self.tintColor
            v.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
            v.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
            v.clipsToBounds = true
            v.layer.cornerRadius = 5
            v.alpha = 0
            points.append(v)
        }
        stackView = UIStackView(arrangedSubviews: points)
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func run()
    {
        self.layer.removeAllAnimations()
        let scale1: CGFloat = 1.2
        let scale2: CGFloat = 0.5
        UIView.animateKeyframes(withDuration: 4.0, delay: 0, options: [.calculationModeLinear, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0/8.0, animations: {
                self.points[0].alpha = 1
                self.points[0].transform = CGAffineTransform(scaleX: scale1, y: scale1)
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0/8.0, relativeDuration: 3.0/8.0, animations: {
                self.points[1].alpha = 1
                self.points[1].transform = CGAffineTransform(scaleX: scale1, y: scale1)
                self.points[0].transform = CGAffineTransform(scaleX: scale2, y: scale2)
                self.points[0].alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 4.0/8.0, relativeDuration: 3.0/8.0, animations: {
                self.points[2].alpha = 1
                self.points[2].transform = CGAffineTransform(scaleX: scale1, y: scale1)
                self.points[1].transform = CGAffineTransform(scaleX: scale2, y: scale2)
                self.points[1].alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 7.0/8.0, relativeDuration: 1.0/8.0, animations: {
                self.points[2].transform = CGAffineTransform(scaleX: scale2, y: scale2)
                self.points[2].alpha = 0
            })
        })
        cloud()
    }
    
    func cloud() {
        if cloudLayer == nil {
            let cloudPath = UIBezierPath()
            cloudPath.move(to: CGPoint(x: 22, y: 22))
            cloudPath.addArc(withCenter: CGPoint(x: 22, y: 42), radius: 20,
                             startAngle: CGFloat(-Float.pi / 2), endAngle: CGFloat(Float.pi / 2), clockwise: false)
            cloudPath.addLine(to: CGPoint(x: 73, y: 62))
            cloudPath.addArc(withCenter: CGPoint(x: 73, y: 42), radius: 20,
                             startAngle: CGFloat(Float.pi / 2), endAngle: CGFloat(-Float.pi / 2), clockwise: false)
            cloudPath.addArc(withCenter: CGPoint(x: 63, y: 22), radius: 10,
                             startAngle: CGFloat(0), endAngle: CGFloat(-5 * Float.pi / 8), clockwise: false)
            cloudPath.addArc(withCenter: CGPoint(x: 42, y: 22), radius: 20,
                             startAngle: CGFloat(-Float.pi / 4), endAngle: CGFloat(Float.pi), clockwise: false)
            cloudPath.close()
            cloudPath.stroke()
            
            let bcloudLayer = CAShapeLayer()
            bcloudLayer.lineWidth = 3
            bcloudLayer.path = cloudPath.cgPath
            bcloudLayer.strokeColor = color?.withAlphaComponent(0.25).cgColor
            bcloudLayer.fillColor = UIColor.clear.cgColor
            layer.addSublayer(bcloudLayer)

            cloudLayer = CAShapeLayer()
            cloudLayer.lineWidth = 3
            cloudLayer.path = cloudPath.cgPath
            cloudLayer.strokeColor = color?.cgColor
            cloudLayer.fillColor = UIColor.clear.cgColor
            bcloudLayer.addSublayer(cloudLayer)
        }
        
        let group = CAAnimationGroup()
        group.duration = 10
        group.repeatCount = Float.infinity
        
        let pathSS = CABasicAnimation(keyPath: "strokeStart")
        pathSS.fromValue = -1
        pathSS.toValue = 1
        let pathSE = CABasicAnimation(keyPath: "strokeEnd")
        pathSE.fromValue = 0
        pathSE.toValue = 1

        group.animations = [pathSS, pathSE]
        cloudLayer.add(group, forKey: nil)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
