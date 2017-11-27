//
//  RegisterHeaderView.swift
//  OrderPay
//
//  Created by answer.zou on 17/11/5.
//  Copyright © 2017年 answer.zou. All rights reserved.
//

import UIKit

typealias NextStepClick = ()->()


class RegisterHeaderView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var verificationCodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var confirPasswordBottomLine: UIView!
    @IBOutlet weak var confirPasswordTextField: UITextField!
    
    var nextStepBlock: NextStepClick?
    
    var timeNumber:NSInteger = 60
    var timer:Timer?
    
    override func draw(_ rect: CGRect) {
        UIView.addShadow(shadowColor: Shadow_backGroundColor ,shadowOffset: CGSize.init(width: 0, height: 2), shadowRadius: 3, shadowOpacity: 0.7, cornerRadius: 5, masksToBounds: true, toView: self.contentView)
    }
    
    func startTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timeNumber = 60
        //创建定时器
        timer = Timer.scheduledTimer(timeInterval: 1, target: YYWeakProxy.init(target: self), selector: #selector(timeCountDown), userInfo: nil, repeats: true)
    }
    
    func timeCountDown() {
        if timeNumber == 0 {
            verificationCodeBtn.isEnabled = true
            self.timer?.invalidate()
            self.timer = nil
            self.verificationCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
            self.verificationCodeBtn.setTitleColor(Gradient_Right_Color, for: .normal)
        }else{
            verificationCodeBtn.isEnabled = false
            timeNumber -= 1
            let sendMessageStr = NSString.init(format: "%02ds", timeNumber)
            self.verificationCodeBtn.setTitle(sendMessageStr as String, for: UIControlState.normal)
            self.verificationCodeBtn.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }

    
    @IBAction func verificationAction(_ sender: UIButton) {
        let mobile = self.accountTextField.text ?? ""
        
        if self.accountTextField.text?.isEmpty == true {
            SVProgressHUD.showError(withStatus: "请先输入手机号")
            return
        }
        let pid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let params = ["mobile": mobile, "type": "1", "pid": pid] as NSDictionary
        SmCodeViewModel.requestData(params: params) { [unowned self] in
            self.startTimer()
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if self.passwordTextField.text != self.confirPasswordTextField.text {
            SVProgressHUD.showError(withStatus: "两次密码不一致，请重新输入")
            self.confirPasswordBottomLine.backgroundColor = UIColor.red
            
            return
        }
        
        if self.nextStepBlock != nil {
            self.nextStepBlock!()
        }
    }
    

}
