//  LetterControl.swift
//  Lesson1.1
//  Created by Iv on 16/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class LetterControl: UIControl {

    var Letters: [String] = []
    var selectedLetter: String? = nil {
        didSet {
            self.updateSelectedChar()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    private var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupLetters(_ letters: [String]) {
        
        Letters.removeAll()
        for val in letters {
            Letters.append(val)
        }
        buttons.removeAll()
        for val in Letters {
            let button = UIButton(type: .system)
            button.setTitle(val, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .alignAllCenterY, metrics: nil, views: ["scrollView": scrollView]))
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: .alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: .alignAllCenterY, metrics: nil, views: ["stackView": stackView]))
    }
    
    private func updateSelectedChar() {
        for button in self.buttons {
            if let sl = selectedLetter {
                button.isSelected = sl == button.titleLabel?.text
            } else {
                button.isSelected = false
            }
        }
    }
    
    @objc private func selectLetter(_ sender: UIButton) {
        self.selectedLetter = sender.titleLabel?.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //scrollView.frame = bounds
        //scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
