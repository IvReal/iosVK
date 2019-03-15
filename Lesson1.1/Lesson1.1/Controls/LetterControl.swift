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
        setupView()
    }
    
    private func setupView() {
        if Letters.isEmpty {
            for val in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
                Letters.append(String(val))
            }
        }
        for val in Letters {
            let button = UIButton(type: .system)
            button.setTitle(val, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
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
        stackView.frame = bounds
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
