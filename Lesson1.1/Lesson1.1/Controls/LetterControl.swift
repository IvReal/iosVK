//  LetterControl.swift
//  Lesson1.1
//  Created by Iv on 16/03/2019.
//  Copyright © 2019 Iv. All rights reserved.

import UIKit

class LetterControl: UIControl {

    @IBInspectable var scrollable: Bool = false   // TODO: stackView in scrollView is not centered
    // available letters array
    var Letters: [String] = [] {
        didSet {
            for button in buttons {
                stackView.removeArrangedSubview(button)
                button.removeFromSuperview()
            }
            buttons.removeAll()
            for val in Letters {
                let button = UIButton(type: .system)
                button.setTitle(val, for: .normal)
                button.setTitleColor(self.tintColor, for: .normal)
                button.setTitleColor(.white, for: .selected)
                button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
                buttons.append(button)
                stackView.addArrangedSubview(button)
            }
        }
    }
    var selectedLetter: String? = nil {
        didSet {
            self.updateSelectedChar()
            self.sendActions(for: .valueChanged)
        }
    }
    var changeLetterHandler: ((String) -> Void)? = nil
    
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

    private func setupView() {
        if scrollable {
            scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(scrollView)
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView": scrollView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .init(rawValue: 0), metrics: nil, views: ["scrollView": scrollView]))
        }
        stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        if scrollable {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(stackView)
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: .init(rawValue: 0), metrics: nil, views: ["stackView": stackView]))
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: .init(rawValue: 0), metrics: nil, views: ["stackView": stackView]))
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[stackView(==scrollView)]", options: .init(rawValue: 0), metrics: nil, views: ["stackView": stackView, "scrollView": scrollView]))
        } else {
            self.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: .init(rawValue: 0), metrics: nil, views: ["stackView": stackView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: .init(rawValue: 0), metrics: nil, views: ["stackView": stackView]))
        }
    }
    
    // set buttons status according to selected letter
    private func updateSelectedChar() {
        for button in self.buttons {
            if let sl = selectedLetter {
                button.isSelected = sl == button.titleLabel?.text
            } else {
                button.isSelected = false
            }
        }
    }
    
    // button tap handler
    @objc private func selectLetter(_ sender: UIButton) {
        self.selectedLetter = sender.titleLabel?.text
        // if external handler assigned call it
        if let handler = changeLetterHandler,
           let letter = selectedLetter
        {
            handler(letter)
        }
    }
    
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        if !scrollable {
            stackView.frame = bounds
        }
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
    }
    */
}
