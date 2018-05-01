//
//  RCSelectionButton.swift
//  Recap
//
//  Created by Jonah Siegle on 2015-07-31.
//  Copyright (c) 2015 Jonah Siegle. All rights reserved.
//

import UIKit

class SelectionButton: UIButton {

    override var isHighlighted: Bool {

        get{ return false }
        
        set {
            super.isHighlighted = isHighlighted
            self.titleLabel?.alpha = 1.0
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.7
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder:coder)
        setup()
    }

    fileprivate func setup() {
        self.adjustsImageWhenHighlighted = false
        self.addTarget(self, action: #selector(SelectionButton.fadeOut), for: .touchDown)
        self.addTarget(self, action: #selector(SelectionButton.fadeIn), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        self.setTitleColor(self.titleLabel?.textColor, for: .highlighted)
        self.setTitleColor(self.titleLabel?.textColor, for: UIControlState())
        self.setTitleColor(self.titleLabel?.textColor, for: .selected)
    }

    @objc func fadeOut() {
        self.isHighlighted = false
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0.7
        })
    }

    @objc func fadeIn() {
        self.adjustsImageWhenHighlighted = false
        self.alpha = 0.7
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
        })
    }
}
