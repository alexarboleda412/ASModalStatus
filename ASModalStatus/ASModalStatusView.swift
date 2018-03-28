//
//  ASModalStatusView.swift
//  ASModalStatus
//
//  Created by Alex Arboleda on 3/27/18.
//  Copyright © 2018 Alex Arboleda. All rights reserved.
//

import UIKit

public class ASModalStatusView: UIView {

    @IBOutlet private weak var statusImage: UIImageView!
    @IBOutlet private weak var headLineLabel: UILabel!
    @IBOutlet private weak var subheadLineLabel: UILabel!

    let nibName = "ASModalStatusView"
    var contentView: UIView!
    var timer: Timer?
    var timerCount: Timer?
    var timeCount: Double = 0
    var time: TimeInterval = 3.0

    public override func didMoveToSuperview() {
        // Fade in when added to superview
        // Then add a timer to remove the view
        self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.contentView.alpha = 1.0
                self.contentView.transform = CGAffineTransform.identity
        }) { _ in
            self.timer = Timer.scheduledTimer(
                timeInterval: TimeInterval(self.time),
                target: self,
                selector: #selector(self.removeSelf),
                userInfo: nil,
                repeats: false)
            self.timerCount = Timer.scheduledTimer(
                timeInterval: TimeInterval(1.0),
                target: self,
                selector: #selector(self.updateTimer),
                userInfo: nil,
                repeats: true)
            self.updateTimer()
        }
    }

    @objc private func removeSelf() {
        // Animate removal of view
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.contentView.alpha = 0.0
                self.timerCount?.invalidate()
        }) { _ in
            self.removeFromSuperview()
        }
    }

    @objc private func updateTimer() {
        subheadLineLabel.text = "\(time - timeCount)"
        timeCount += 1
    }

    // Allow view to control itself
    public override func layoutSubviews() {
        // Rounded corners
        self.layoutIfNeeded()
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }

    // MARK: Setup View
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(contentView)

        contentView.center = self.center
        contentView.autoresizingMask = []
        contentView.translatesAutoresizingMaskIntoConstraints = true

        headLineLabel.text = ""
        subheadLineLabel.text = ""

        contentView.alpha = 0.0
    }

    // Provide functions to update view
    public func set(time: TimeInterval) {
        self.time = time
    }

    public func set(image: UIImage) {
        self.statusImage.image = image
    }

    public func set(headline text: String) {
        self.headLineLabel.text = text
    }

    public func set(subheading text: String) {
        self.subheadLineLabel.text = text
    }
}
