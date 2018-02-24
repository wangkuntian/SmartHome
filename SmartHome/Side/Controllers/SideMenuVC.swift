//
//  SideMenuVC.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/8.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import Pastel
import UICollectionViewLeftAlignedLayout
import SCLAlertView
import AVFoundation

class SideMenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView : UICollectionView!
    
    var optionImageView : UIImageView!
    
    var ipTextField : UITextField!
    
    var portTextField : UITextField!
    
    let titles : [[String]] = [["安防模式","智能模式"],
                               ["家居模式","睡眠模式"]]
    
    let controlTitles : [String] = ["光照强度","烟雾浓度","空气湿度"]
    
    let controlImages : [UIImage] = [#imageLiteral(resourceName: "ic_light"), #imageLiteral(resourceName: "ic_smoke"), #imageLiteral(resourceName: "ic_hum")]
    
    let collectionImagesOff = [[#imageLiteral(resourceName: "ic_safe_off"), #imageLiteral(resourceName: "ic_smart_off")],
                               [#imageLiteral(resourceName: "ic_house_off"), #imageLiteral(resourceName: "ic_sleep_off")]]
    
    let collectionImagesOn = [[#imageLiteral(resourceName: "ic_safe_on"), #imageLiteral(resourceName: "ic_smart_on")],
                              [#imageLiteral(resourceName: "ic_house_on"), #imageLiteral(resourceName: "ic_sleep_on")]]
    
    
    var data : [[Bool]] = [[Control.share.safe, Control.share.smart]]
    
    var controlData : [Double] = [Monitor.now.light,Monitor.now.smoke, Monitor.now.hum]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        data = [[Control.share.safe, Control.share.smart]]
        
        controlData = [Monitor.now.light,Monitor.now.smoke, Monitor.now.hum]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(smokeChanged), name: NSNotification.Name.init(rawValue: "Smog"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(lightChanged), name: NSNotification.Name.init(rawValue: "Light"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(humChanged), name: NSNotification.Name.init(rawValue: "Hum"), object: nil)
        
    }
    
    @objc func smokeChanged() {
    
        print("=========Smoke changed==========")
        controlData = [Monitor.now.light,Monitor.now.smoke, Monitor.now.hum]
        let indexPath = IndexPath(row: 1, section: 2)
        self.collectionView.reloadItems(at: [indexPath])
        
    }
    @objc func lightChanged() {
        
        print("=========Light changed==========")
        
        controlData = [Monitor.now.light,Monitor.now.smoke, Monitor.now.hum]
        let indexPath = IndexPath(row: 0, section: 2)
        self.collectionView.reloadItems(at: [indexPath])
        
    }
    
    @objc func humChanged() {
        
        print("=========Hum changed==========")
        
        controlData = [Monitor.now.light,Monitor.now.smoke, Monitor.now.hum]
        let indexPath = IndexPath(row: 2, section: 2)
        self.collectionView.reloadItems(at: [indexPath])
        
    }
    
    //MARK: - 初始化视图
    func initViews() {
        
        initNavBar()
        
        initBackgroundView()
        
        initCollectionView()
        
        initOptionImageView()
        
    }
    
    //MARK: - 初始化导航栏
    func initNavBar() {
        
        let navigationBar : UINavigationBar = (self.navigationController?.navigationBar)!
        
        let frame = navigationBar.frame
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + 10 * HeightScale)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.textFont(with: 20)!,NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.navigationItem.title = "控制中心"
        
    }
    
    
    //MARK - 初始化背景
    func initBackgroundView() {
        
        let pastelBackgroundView = PastelView()
        self.view.insertSubview(pastelBackgroundView, at: 0)
        
        pastelBackgroundView.snp.makeConstraints { (make) in
            
            make.top.bottom.left.right.equalTo(0)
            
        }
        pastelBackgroundView.startPastelPoint = .bottom
        pastelBackgroundView.endPastelPoint = .top
        
        pastelBackgroundView.animationDuration = 6.0
        
        
        //UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
        pastelBackgroundView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                        UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                        UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                        UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                        UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                        UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        pastelBackgroundView.startAnimation()
        
    }
    
    //MARK: - 初始化collectionView
    func initCollectionView() {
    
        let layout = UICollectionViewLeftAlignedLayout()
        
        
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!, width: ScreenSize.width, height: ScreenSize.height), collectionViewLayout: layout)
        
        self.view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SideMenuCollectionCell.classForCoder(), forCellWithReuseIdentifier: SideMenuCollectionCell.cellID)
        collectionView.register(ControlCollectionCell.classForCoder(), forCellWithReuseIdentifier: ControlCollectionCell.cellID)
    
    }
    
    //MARK: - 初始化optionImageView
    func initOptionImageView() {
        
        optionImageView = UIImageView()
        self.view.addSubview(optionImageView)
        
        optionImageView.snp.makeConstraints { (make) in
            
            make.left.equalTo(25 * WidthScale)
            make.bottom.equalTo(-30 * HeightScale)
            make.width.height.equalTo(65 * HeightScale)
            
        }
        optionImageView.image = #imageLiteral(resourceName: "ic_option")
        optionImageView.contentMode = .scaleAspectFit
        optionImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(optionImageViewTapped))
        optionImageView.addGestureRecognizer(tap)
        
    }
    
    //MARK: - optionImageView Tapped
    @objc func optionImageViewTapped(){
        
        let appearance = SCLAlertView.SCLAppearance(
            
            kDefaultShadowOpacity : 0.1,
            shouldAutoDismiss : false
            
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("确定") {
            
            let ip : String? = self.ipTextField.text
            let port : String? = self.portTextField.text
            
            if !(ip?.isEmpty)! && !(port?.isEmpty)! {
                
                
                if ip! != RMQConfig.share.ip || port != RMQConfig.share.port {
                    
                    RMQConfig.share.ip = ip!
                    RMQConfig.share.port = port!
                    
                    let userDefault = UserDefaults.standard
                    
                    userDefault.set(ip!, forKey: "ip")
                    userDefault.set(port!, forKey: "port")
                    
                    userDefault.synchronize()
                    
                    
                    
                    RMQTool.channel.close()
                    RMQTool.connection.close()
                    
                    RMQTool.subscribe()
                    
                    let app = SCLAlertView.SCLAppearance(
                        
                        kDefaultShadowOpacity : 0.1
                        
                    )
                    
                    let a = SCLAlertView(appearance: app)
                    a.showSuccess("修改成功！", subTitle: "", closeButtonTitle: "OK", animationStyle: SCLAnimationStyle.bottomToTop)
                    
                    
                }
                
                alert.hideView()

            }
            
        }
        
        ipTextField = alert.addTextField()
        ipTextField.text = RMQConfig.share.ip
        
        portTextField = alert.addTextField()
        portTextField.text = RMQConfig.share.port
        
        alert.showEdit("设置", subTitle: "", closeButtonTitle: "取消", animationStyle: SCLAnimationStyle.bottomToTop)
        
        
    }
    
    //MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 2 {
            
            return 3
            
        }
        
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section < 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SideMenuCollectionCell.cellID, for: indexPath) as! SideMenuCollectionCell
            
            
            cell.titleLabel.text = self.titles[section][row]
            
            if section == 0 {
                
                let flag = self.data[section][row]
                
                cell.iconImageView.image = flag ? self.collectionImagesOn[section][row] : self.collectionImagesOff[section][row]
                
            }else {
                
                cell.iconImageView.image = self.collectionImagesOff[section][row]
                cell.iconImageView.highlightedImage = self.collectionImagesOn[section][row]
                
            }
            
            return cell

        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ControlCollectionCell.cellID, for: indexPath) as! ControlCollectionCell
        cell.titleLabel.text = self.controlTitles[row]
        cell.iconImageView.image = self.controlImages[row]
        cell.detailLabel.text = "\(self.controlData[row])"
        
        return cell
        
    }
    
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            cell?.transform = .identity
            
        }, completion: nil)
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            
            let value = self.data[section][row]
            self.data[section][row] = !value
            
            let cell = cell as! SideMenuCollectionCell
            cell.iconImageView.image = value ? self.collectionImagesOff[section][row] : self.collectionImagesOn[section][row]
            
        }
        if section == 1 {
            
            let cell = cell as! SideMenuCollectionCell
            
            cell.iconImageView.isHighlighted = false
            
        }
        
        switch (section, row) {
            
        case (0,0):
            
            Control.share.safe = self.data[section][row]
            
            if self.data[section][row] {
                
                RMQTool.publish(message: ControlSwitch.safeon.rawValue)
                
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kDefaultShadowOpacity : 0.1,
                    showCloseButton: false,
                    shouldAutoDismiss : true,
                    hideWhenBackgroundViewIsTapped : true
                    
                )
                
                let alert = SCLAlertView(appearance: appearance)
                alert.showSuccess("安防模式已打开", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)
                
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.safeoff.rawValue)
                
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kDefaultShadowOpacity : 0.1,
                    showCloseButton: false,
                    shouldAutoDismiss : true,
                    hideWhenBackgroundViewIsTapped : true
                    
                )

                let alert = SCLAlertView(appearance: appearance)
                alert.showSuccess("安防模式已关闭", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)
                
            }
            
            
        case (0,1):
            
            Control.share.smart = self.data[section][row]
            
            if self.data[section][row] {
                
                RMQTool.publish(message: ControlSwitch.smarton.rawValue)
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kDefaultShadowOpacity : 0.1,
                    showCloseButton: false,
                    shouldAutoDismiss : true,
                    hideWhenBackgroundViewIsTapped : true
                    
                )
                
                
                
                let alert = SCLAlertView(appearance: appearance)
                alert.showSuccess("智能模式已打开", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.smartoff.rawValue)
                let appearance = SCLAlertView.SCLAppearance(
                    
                    kDefaultShadowOpacity : 0.1,
                    showCloseButton: false,
                    shouldAutoDismiss : true,
                    hideWhenBackgroundViewIsTapped : true
                    
                )
                
                let alert = SCLAlertView(appearance: appearance)
                alert.showSuccess("智能模式已关闭", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)
                
            }
            
        case (1,0):
            
            RMQTool.publish(message: ControlSwitch.home.rawValue)
            let appearance = SCLAlertView.SCLAppearance(
                
                kDefaultShadowOpacity : 0.1,
                showCloseButton: false,
                shouldAutoDismiss : true,
                hideWhenBackgroundViewIsTapped : true
                
            )
            
            let alert = SCLAlertView(appearance: appearance)
            alert.showSuccess("家居模式", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)
            
            
            
        case (1,1):
            
            RMQTool.publish(message: ControlSwitch.sleep.rawValue)
            let appearance = SCLAlertView.SCLAppearance(
                
                kDefaultShadowOpacity : 0.1,
                showCloseButton: false,
                shouldAutoDismiss : true,
                hideWhenBackgroundViewIsTapped : true
            )
            
            let alert = SCLAlertView(appearance: appearance)
            alert.showSuccess("睡眠模式", subTitle: "", duration: 2, animationStyle: SCLAnimationStyle.bottomToTop)

        default:
            break
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section < 2 {
            
            return CGSize(width: ScreenSize.width * 0.31 , height: ScreenSize.width * 0.31 * 0.95 )
            
        }
        
        return CGSize(width: ScreenSize.width * 0.65 , height: ScreenSize.width * 0.28 * 0.95 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 0 {
            
            return UIEdgeInsetsMake(60 * HeightScale, 36 * WidthScale, 0, 0)
            
        }
        
        
        return UIEdgeInsetsMake(10 * HeightScale, 36 * WidthScale, 0, 0)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10 * HeightScale
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5 * WidthScale
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
