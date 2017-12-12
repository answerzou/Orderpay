//
//  OrderController.swift
//  OrderPay
//
//  Created by answer.zou on 17/9/25.
//  Copyright © 2017年 answer.zou. All rights reserved.
//

import UIKit

let BackgroundView_Height = CGFloat(75)

class OrderController: BaseController {
    
    let reuseIdentifier = "OrderCell"
    
    //页码
    let page: NSInteger = 1
    
    // 顶部刷新
    var header = MJRefreshNormalHeader()
    
    
    fileprivate lazy var topView:UIView = {
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 70))
        return topView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - StatusBarHeight - NavigationBarHeight), style: .plain)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
//        tableView.backgroundView = self.backgroundView
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    fileprivate lazy var dataArray: NSMutableArray = {
        let dataArr = NSMutableArray.init(capacity: 0)
        
        return dataArr
    }()
    
        
    fileprivate lazy var rightButton: UIButton = {
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
        
        btn.set(image: UIImage(named: "bg_selectCity"), title: "城市", titlePosition: .left,
                additionalSpacing: 10.0, state: UIControlState.normal)
        btn.addTarget(self, action: #selector(selectCity), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.mj_header.beginRefreshing()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "派单"
//        UserModel.shared.custCode = "20171212173233101830"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.rightButton)
        self.view.addSubview(self.topView)
        self.view.addSubview(self.tableView)
        tableView.register(UINib.init(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        self.header = MJRefreshNormalHeader(refreshingBlock: {
            print("下拉刷新.")
            
            self.requestData()
            
        })
        self.tableView.mj_header = self.header
        self.header.lastUpdatedTimeLabel.isHidden = true
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            print("上拉刷新")
            self.tableView.mj_footer.endRefreshing()
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = CAGradientLayer.addGradientLayer(left: Gradient_Left_Color, right:Gradient_Right_Color, toView:self.topView, isnavigationBar: false, removeLayer: nil)
    }
    
}

extension OrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! OrderCell
        let model = self.dataArray[indexPath.row]
        cell.model = model as! OrderModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let detail = OrderDetailController()
//        self.navigationController?.pushViewController(detail, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = self.dataArray[indexPath.row] as! OrderModel
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:ServiceTel]];
        let mobileStr: String = "tel:\(model.mobile ?? "")"
        if mobileStr.count > 0 {
            UIApplication.shared.openURL(URL.init(string: mobileStr)!)
        }
    }

}


extension OrderController: CityListViewDelegate {
    func didClicked(withCityName cityName: String!) {
//        self.cityCode = JYXML.getCodeFromCity(cityName)!
//        print("xxx\(JYXML.getCodeFromCity(cityName)!)")
//        self.city = cityName
        print(cityName)
        rightButton.set(image: UIImage(named: "bg_selectCity"), title: cityName, titlePosition: .left,
                        additionalSpacing: 10.0, state: UIControlState.normal)
    }
    
    func selectCity() {
        JYCitySelectManager.sharedInstance().show { (cityName) in
            print(cityName ?? "")
            let provinceCode = UserDefaults.standard.object(forKey: "LiveProvinceCode")
            let cityCode = UserDefaults.standard.object(forKey: "LiveCityCode")
            let countyCode = UserDefaults.standard.object(forKey: "LiveCountyCode")
            
            print("\(provinceCode) + \(cityCode) +\(countyCode)")
        }
    
    }
    
}

extension OrderController {
    func requestData() {
        let pid = UserModel.shared.pid ?? ""
        let mobile = UserModel.shared.mobile ?? ""
        let curPage = self.page
        let custCode = UserModel.shared.custCode ?? ""
        let params = ["pid": pid, "mobile": mobile, "curPage": curPage, "custCode": custCode] as [String : Any]
        print(params)
        OrderViewModel.requestData(params: params as NSDictionary) { (resultModelArray, requestStatu) in
            print(resultModelArray)
            print(requestStatu)
            if self.page == 1 {
                self.dataArray .removeAllObjects()
                self.dataArray.addObjects(from: resultModelArray as! [Any])
            }else {
                self.dataArray.addObjects(from: resultModelArray as! [Any])
            }
            self.tableView.reloadData()
            //结束刷新
            self.tableView.mj_header.endRefreshing()
        }
    }
}


