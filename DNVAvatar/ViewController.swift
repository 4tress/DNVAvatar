//
//  ViewController.swift
//  DNVAvatar
//
//  Created by Alexey Demin on 18/11/14.
//  Copyright (c) 2014 Alexey Demin. All rights reserved.
//

import UIKit


extension UIColor {
    convenience init(hex: UInt32) {
        self.init(red: CGFloat(hex >> 16 & 0xFF) / 0xFF, green: CGFloat(hex >> 8 & 0xFF) / 0xFF, blue: CGFloat(hex & 0xFF) / 0xFF, alpha: 1)
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var avatarView: DNVAvatarView!
    
    @IBOutlet weak var avatarWidth: NSLayoutConstraint!
    
    @IBAction func zoomDidAdjust(_ sender: UISlider) {
        avatarWidth.constant = CGFloat(sender.value * 160 + 20)
        avatarView.setNeedsDisplay()
    }
    
    enum Mode: Int {
        case one, two, three, four
    }
    var mode = Mode.one
    
    var imagesEnabled = true
    
    @IBAction func modeDidSelect(_ sender: UISegmentedControl) {
        mode = Mode(rawValue: sender.selectedSegmentIndex)!
        setupAvatarView()
    }
    
    @IBAction func imagesDidSwitch(_ sender: UISwitch) {
        imagesEnabled = sender.isOn
        setupAvatarView()
    }
    
    @IBAction func borderDidSwitch(_ sender: UISwitch) {
        avatarView.showsImagesBorder = sender.isOn
    }
    
    @IBAction func reloadImage(_ sender: UIButton) {
    }
    
    var jobsAvatar = DNVAvatar(initials: "SJ", backgroundColor: UIColor(hex: 0x8E8E93))
    var cookAvatar = DNVAvatar(initials: "TC", backgroundColor: UIColor(hex: 0x5856D6))
    var iveAvatar = DNVAvatar(initials: "JI", backgroundColor: UIColor(hex: 0xFF9500))
    var federighiAvatar = DNVAvatar(initials: "CF", backgroundColor: UIColor(hex: 0xFF2D55))
    
    let jobsImage = UIImage(named: "Steve Jobs")
    let cookImage = UIImage(named: "Tim Cook")
    let iveImage = UIImage(named: "Jonathan Ive")
    let federighiImage = UIImage(named: "Craig Federighi")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatarView()
    }

    
    func setupAvatarView() {
        
        switch mode {
        case .one:
            avatarView.avatar1 = jobsAvatar
            avatarView.avatar2 = nil
            avatarView.avatar3 = nil
            avatarView.avatar4 = nil
        case .two:
            avatarView.avatar1 = iveAvatar
            avatarView.avatar2 = federighiAvatar
            avatarView.avatar3 = nil
            avatarView.avatar4 = nil
        case .three:
            avatarView.avatar1 = cookAvatar
            avatarView.avatar2 = iveAvatar
            avatarView.avatar3 = federighiAvatar
            avatarView.avatar4 = nil
        case .four:
            avatarView.avatar1 = federighiAvatar
            avatarView.avatar2 = cookAvatar
            avatarView.avatar3 = jobsAvatar
            avatarView.avatar4 = iveAvatar
        }
        
        if imagesEnabled {
            jobsAvatar.image = jobsImage
            cookAvatar.image = cookImage
            iveAvatar.image = iveImage
            federighiAvatar.image = federighiImage
        }
        else {
            jobsAvatar.image = nil
            cookAvatar.image = nil
            iveAvatar.image = nil
            federighiAvatar.image = nil
        }
    }
}

