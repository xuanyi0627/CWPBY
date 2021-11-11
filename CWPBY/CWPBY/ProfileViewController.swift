//
//  ProfileViewController.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/12/1.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    /// 版本信息Label
    @IBOutlet private weak var versionLabel: UILabel! {
        didSet {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1"
            versionLabel.text = "version: \(version)"
        }
    }
    
    
    @IBOutlet private weak var logoView: UIView! {
        didSet {
            logoView.layer.masksToBounds = true
            logoView.layer.cornerRadius = 50
        }
    }
    
    @IBOutlet private weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.layer.cornerRadius = 48
            logoImageView.layer.masksToBounds = true
        }
    }
    
     /// 进入到App Store评价App
     func rateInAppStore() {
        let evaluateString = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1181843646&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        UIApplication.shared.open(URL(string: evaluateString)!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
