//
//  SelectImageViewController.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/11/30.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import UIKit
import PopupDialog
import SafariServices
import UIImageColors

class SelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate {
    
    
    /// 跳转到预览页面的Segue identifier
    private struct StoryboardSegue {
        static let ShowPreviewSegue = "Show Preview"
    }
    
    /// 用户选择的壁纸照片
    private var faceImage: UIImage?

    ///壁纸照片做Blur后的效果
    private var bgImage: UIImage? {
        get {
            // 如果壁纸blur过程产生nil，则用占位壁纸blur效果代替
            return self.faceImage?.applyLightEffect() ?? UIImage(named: "temp_face")!.applyLightEffect()!
        }
    }
    
    /// 壁纸的主要用色
    private var imageColors: UIImageColors? {
        get {
            return self.faceImage?.getColors()
        }
    }
    
    /// 时间Label
    @IBOutlet private weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = Date().currentTime()
        }
    }
    
    /// 日期Label（日期和星期）
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            let time = Date()
            dateLabel.text = "\(time.currentDate()) \(time.currentWeek())"
        }
    }
    

    @IBOutlet private weak var bgImageView: UIImageView! {
        didSet {
            bgImageView.image = UIImage(named: "temp_face")!
        }
    }
    
    /// 设置壁纸引导图
    @IBOutlet private weak var faceImageView: UIImageView! {
        didSet {
            faceImageView.layer.cornerRadius = 14
            faceImageView.layer.masksToBounds = true
            faceImageView.image = UIImage(named: "temp_face")!
        }
    }
    
    /// 选择壁纸的按钮
    @IBOutlet private weak var selectFaceImageBtn: UIButton! {
        didSet {
            selectFaceImageBtn.layer.cornerRadius = 14
            selectFaceImageBtn.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 点击个人信息按钮的触发事件
    ///
    /// - Parameter sender: 个人信息按钮
    @IBAction private func toProfile(_ sender: UIButton) {
        
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        let popup = PopupDialog(viewController: profileVC, buttonAlignment: .vertical, transitionStyle: .bounceDown, gestureDismissal: true)
        
        let rateBtn = DefaultButton(title: "Rate") {
            profileVC.rateInAppStore()
        }
        rateBtn.titleColor = UIColor(hex: 0xFF7360)
        let githubBtn = DefaultButton(title: "Github") {
            self.toGithub()
        }
        githubBtn.titleColor = UIColor(hex: 0xFF7360)
        let cancelBtn = CancelButton(title: "Cancel") {
            
        }
        popup.addButtons([githubBtn,rateBtn,cancelBtn])
        present(popup, animated: true, completion: nil)
    }
    
    @IBAction private func selectFaceImage(_ sender: UIButton) {
        // 检测设备的相册是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("设备的相册不可用")
            return
        }
        
        // 调用系统相册
        let picVC = UIImagePickerController()
        picVC.sourceType = .photoLibrary
        picVC.allowsEditing = true
        picVC.delegate = self
        present(picVC, animated: true, completion: nil)
    }
    
    
    /// 系统相册回调，当选择壁纸完成时发起
    ///
    /// - Parameters:
    ///   - picker: 系统相册
    ///   - info: 图片的相关属性
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 获取到编辑后的图片，如果没有用占位图片代替
        faceImage = info[UIImagePickerControllerEditedImage] as? UIImage ?? UIImage(named: "temp_face")!
        dismiss(animated: true, completion: {
            // 选择后进入预览页面
            self.performSegue(withIdentifier: StoryboardSegue.ShowPreviewSegue, sender: nil)
        })
    }
    
    
    /// 进入个人的Github 直接在App内部调用Safari
    private func toGithub() {
        let github = "https://github.com/xuanyi0627"
        let weburl = URL(string: github)!
        let safariVC = SFSafariViewController(url: weburl)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }
    
    
    /// 调用Safari的回调
    ///
    /// - Parameter controller: SFSafariViewController
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("closed safari")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == StoryboardSegue.ShowPreviewSegue {
            if let previewVC = segue.destination as? PreViewController {
                previewVC.faceImage = faceImage!
                previewVC.bgImage = bgImage!
                previewVC.imageColors = imageColors
            }
        }
    }
    

}
