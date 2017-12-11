//
//  RealNameView.swift
//  OrderPay
//
//  Created by answer.zou on 17/11/8.
//  Copyright © 2017年 answer.zou. All rights reserved.
//

import UIKit

typealias RegisterBtnBlock = ()->()
typealias SkipBtnBlock = ()->()
let RealNameTF = 0
let IdCardTF = 1
let CompanyNameTF = 2
let CityTF = 666

class RealNameView: UIView {
    @IBOutlet weak var contenView: UIView!

    @IBOutlet weak var realNameTextField: UITextField!
    
    @IBOutlet weak var idCardTextField: UITextField!

    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var cityBtn: UIButton!
    var registerBtnBlock: RegisterBtnBlock?
    var skipBtnBlock: SkipBtnBlock?
    
    ///真实Str
    var realNameStr: String = ""
    ///身份证Str
    var idCardStr: String = ""
    ///公司名称Str
    var companyNameStr: String = ""
    ///所在城市Str
    var cityStr: String = ""
    
    
    @IBAction func cityBtnAction(_ sender: UIButton) {
        
        JYCitySelectManager.sharedInstance().show { (cityName) in
            
            print(cityName ?? "")
            
            let provinceCode = UserDefaults.standard.object(forKey: "LiveProvinceCode")
            let cityCode = UserDefaults.standard.object(forKey: "LiveCityCode")
            let countyCode = UserDefaults.standard.object(forKey: "LiveCountyCode")
            
            if (cityName?.isEmpty)! {
                
            }else {
                
                self.cityStr = cityName!
                self.cityBtn.setTitle(cityName, for: .normal)
                self.cityBtn.setTitleColor(.black, for: .normal)
            }
            
        }
    }
    
    //实名认证按钮
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        if self.registerBtnBlock != nil {
            self.registerBtnBlock!()
        }
    }
    //跳过按钮
    @IBAction func skipBtnAction(_ sender: UIButton) {
        if self.skipBtnBlock != nil {
            self.skipBtnBlock!()
        }
    }
    
    override func draw(_ rect: CGRect) {
        UIView.addShadow(shadowColor: Shadow_backGroundColor ,shadowOffset: CGSize.init(width: 0, height: 2), shadowRadius: 3, shadowOpacity: 0.7, cornerRadius: 5, masksToBounds: true, toView: self.contenView)
    }
   
}

extension RealNameView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        
    
        switch textField.tag {
        case RealNameTF:
            self.realNameStr = newString ?? ""
        case IdCardTF:
            self.idCardStr = newString ?? ""
        case CompanyNameTF:
            self.companyNameStr = newString ?? ""
        default: break
            
        }
        
        
        if self.realNameStr.isEmpty || self.idCardStr.isEmpty || self.companyNameStr.isEmpty || self.cityStr.isEmpty{
            self.registerBtn.isEnabled = false
        }else {
            self.registerBtn.isEnabled = true
        }
        
        return true
    }

}
