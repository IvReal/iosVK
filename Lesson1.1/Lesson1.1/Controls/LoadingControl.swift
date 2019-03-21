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
        run()
    }
    
    private func run()
    {
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
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
