//
//  PreViewController.swift
//  CWPBY
//
//  Created by Xuanyi Liu on 2016/12/1.
//  Copyright © 2016年 Xuanyi Liu. All rights reserved.
//

import UIKit
import Photos
import UIImageColors

class PreViewController: UIViewController, UIImagePickerControllerDelegate {

    
    /// 壁纸图片
    var faceImage: UIImage?
    /// 壁纸Blur背景图片
    var bgImage: UIImage?
    
    /// 是否为预览模式
    private var isPreview: Bool {
        get {
            return self.isPreview
        }
        
        set {
            toolbar.isHidden = newValue
            stackView.isHidden = !newValue
            if newValue {
                UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    self.stackViewToTop.constant = 35
                    self.lockToBottm.constant = 33
                    self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                    self.toolbarToBottm.constant = -44
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.stackViewToTop.constant = -152
                    self.lockToBottm.constant = -54
                    self.view.layoutIfNeeded()
                }, completion: nil)
                UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                    self.toolbarToBottm.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    /// 壁纸图片是否已经保存过
    private var isSaved = false
    
    /// 壁纸图片的取色
    var imageColors: UIImageColors?
    
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var toolbar: UIToolbar!
    
    @IBOutlet private weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = Date().currentTime()
        }
    }
    
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            let time = Date()
            dateLabel.text = "\(time.currentDate()) \(time.currentWeek())"
        }
    }
    
    /// 想要生成的壁纸，要截取这个View上的图
    @IBOutlet private weak var shotView: UIView!
    @IBOutlet private weak var bgImageView: UIImageView!
    
    @IBOutlet private weak var shadowView: RadiusShadowView!
    
    @IBOutlet private weak var faceImageView: UIImageView! {
        didSet {
            faceImageView.layer.cornerRadius = 14
            faceImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet private weak var stackViewToTop: NSLayoutConstraint!
    @IBOutlet private weak var toolbarToBottm: NSLayoutConstraint!
    @IBOutlet private weak var lockToBottm: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceImageView.image = faceImage ?? UIImage(named: "temp_face")
        bgImageView.image = bgImage ?? UIImage(named: "temp_bg")
        isPreview = false
        shadowView.shadowColor = imageColors?.backgroundColor.withAlphaComponent(0.3) ?? UIColor.white.withAlphaComponent(0.3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 退出预览模式
    ///
    /// - Parameter sender: 点击手势
    @IBAction private func backPreviewModel(_ sender: UITapGestureRecognizer) {
        isPreview = false
    }
    
    
    /// 是否放弃编辑 当没有存储图片时会提示，保存过的就不会提示
    private func alertForGiveUp() {
        
        //使用系统提示框
        let alertVC = UIAlertController(title: "提示", message: "是否放弃编辑", preferredStyle: .alert)
        let commitAlert = UIAlertAction(title: "放弃", style: .default, handler: {(UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAlert = UIAlertAction(title: "取消", style: .cancel, handler: {(UIAlertAction) -> Void in
        })
        alertVC.addAction(commitAlert)
        alertVC.addAction(cancelAlert)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    /// 放弃编辑
    ///
    /// - Parameter sender: 放弃编辑按钮
    @IBAction private func giveUpToCreate(_ sender: UIBarButtonItem) {
        //如果已经存储过了就不会提示警告
        if isSaved {
            dismiss(animated: true, completion: nil)
        } else {
            alertForGiveUp()
        }
    }
    
    /// 进入／退出预览模式
    ///
    /// - Parameter sender: 进入／退出预览模式按钮
    @IBAction private func previewImage(_ sender: UIBarButtonItem) {
        isPreview = true
    }
    
    /// 把生成的图片保存在本地 如果已经保存过了就不会再次保存了
    ///
    /// - Parameter sender: 保存图片按钮
    @IBAction private func downloadImage(_ sender: UIBarButtonItem) {
        if !isSaved {
            takeShotForWP()
        }
        else {
            FRDToast.showInfo("已经保存过了")
        }
    }
    
    
    /// 截获指定View上的内容为图片，截取成功后保存到相册 使用Photos框架
    private func takeShotForWP() {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        shotView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image!)
        }, completionHandler: {
            (isSuccess: Bool, error: Error?) in
            if isSuccess {
                self.isSaved = true
                DispatchQueue.main.async(execute: { 
                    FRDToast.showSuccess("保存成功")
                })
            } else{
                DispatchQueue.main.async(execute: {
                    FRDToast.showError("保存失败")
                })
                print("保存失败：", error!.localizedDescription)
            }
        })
    }
    
    

}
