//
//  MainVC.swift
//  SmartPhone
//
//  Created by 王坤田 on 2017/11/7.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import Pastel
import CHIPageControl
import AnimatedCollectionViewLayout

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainTableCellDelegate{
    
    //BDSClientWakeupDelegate, 
    
    var pastelBackgroundView : PastelView!
    
    var collectionView : UICollectionView!
    
    var tableView : UITableView!
    
    var collectionCurrentIndex : Int = 0
    
    var pageControl : CHIBasePageControl!
    
    let images : [UIImage] = [#imageLiteral(resourceName: "ic_livingroom"),#imageLiteral(resourceName: "ic_study"),#imageLiteral(resourceName: "ic_bedroom")]
    
    let icons : [UIImage] = [#imageLiteral(resourceName: "ic_sofa"),#imageLiteral(resourceName: "ic_desk"),#imageLiteral(resourceName: "ic_bed")]
    
    //var titles : [String] = ["LIVING ROOM","STUDY","BEDROOM"]
    let titles : [String] = ["客厅","书房","卧室"]
    
    var data : [[Bool]] = [[]]
    
    let cellImagesOff : [[UIImage]] = [[#imageLiteral(resourceName: "ic_light_off")],
                                       [#imageLiteral(resourceName: "ic_light_off")],
                                       [#imageLiteral(resourceName: "ic_light_off"),#imageLiteral(resourceName: "ic_light_off"),#imageLiteral(resourceName: "ic_fan_off"),#imageLiteral(resourceName: "ic_curtain_off")]
                                      ]
    
    let cellImagesOn : [[UIImage]] = [[#imageLiteral(resourceName: "ic_light_on")],
                                      [#imageLiteral(resourceName: "ic_light_on")],
                                      [#imageLiteral(resourceName: "ic_light_on"),#imageLiteral(resourceName: "ic_light_on"),#imageLiteral(resourceName: "ic_fan_on"),#imageLiteral(resourceName: "ic_curtain_on")]
                                     ]
    
//    let cellTitles : [[String]] = [["Light"],
//                                   ["Light"],
//                                   ["Light",
//                                    "Light",
//                                    "Fan",
//                                    "Curtain"]
    
    let cellTitles : [[String]] = [["电灯"],
                                   ["电灯"],
                                   ["电灯",
                                    "电灯",
                                    "风扇",
                                    "窗帘"]
                                  ]
    
    var temps : [Double] = [Monitor.now.temp, Monitor.now.temp, Monitor.now.temp]
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        data = [[Control.share.livingRoomLight],
                [Control.share.studyLight],
                [Control.share.bedroomLightA,
                 Control.share.bedroomLightB,
                 Control.share.fan,
                 Control.share.curtain
                ]
               ]
        temps = [Monitor.now.temp, Monitor.now.temp, Monitor.now.temp]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tempChanged), name: NSNotification.Name.init(rawValue: "Temp"), object: nil)
        
    }
    
    @objc func tempChanged() {
        
        print("=========Temp changed==========")
        
        temps = [Monitor.now.temp, Monitor.now.temp, Monitor.now.temp]
        
        self.collectionView.reloadData()
       
        
    }
    
    //MARK:- 初始化界面
    func initViews() {
        
        initNavBar()
        
        initBackground()
        
        initTableView()
        
        initCollectionView()
        
        animate()
        
        
        
    }
    
    //MARK: - 初始化导航栏
    func initNavBar() {
        
        let navigationBar : UINavigationBar = (self.navigationController?.navigationBar)!
        
        let frame = navigationBar.frame
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + 10 * HeightScale)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.textFont(with: 20)!,NSAttributedStringKey.foregroundColor : UIColor.white]
        
        //self.navigationItem.title = "SMART HOME"
        self.navigationItem.title = "智能家居"
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(showSideMenu))
        let leftBarButton = UIBarButtonItem.createBarButtonItem(with:#imageLiteral(resourceName: "ic_list"), and: leftTap)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(speechRecognize))
        let rightBarButton = UIBarButtonItem.createBarButtonItem(with: #imageLiteral(resourceName: "ic_mic"), and: rightTap)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    
    //MARK: - 打开侧边栏
    @objc func showSideMenu() {
        
        self.mm_drawerController.toggle(.left, animated: true) { (finsh) in
            
        }
        
        
    }
    
    //MARK: - 语音识别
    @objc func speechRecognize() {
        
        let vc = SpeechVC()
        self.present(UINavigationController.init(rootViewController: vc), animated: true, completion: nil)
        
        /*
        self.asrEventManager.setParameter("", forKey: BDS_ASR_AUDIO_FILE_PATH)
        
        self.fileHandler = self.createFileHandle(With: "recoder.pcm", isAppend: false)
        
        let paramsObject : BDRecognizerViewParamsObject = BDRecognizerViewParamsObject()
        paramsObject.isShowTipAfterSilence = true
        paramsObject.isShowHelpButtonWhenSilence = false
        paramsObject.tipsTitle = "您可以这样说"
        paramsObject.tipsList = ["打开窗帘","关闭风扇","打开书房的电灯"]
        paramsObject.waitTime2ShowTip = 0.5
        paramsObject.isHidePleaseSpeakSection = true
        paramsObject.disableCarousel = true
        
        let recognizerViewController : BDRecognizerViewController = BDRecognizerViewController(recognizerViewControllerWithOrigin: CGPoint.init(x: 9, y: 80), theme: BDTheme.default(), enableFullScreen: true, paramsObject: paramsObject, delegate: self)
        recognizerViewController.startVoiceRecognition()
        */
        
    }
    
    func createFileHandle(With name : String, isAppend : Bool) -> FileHandle? {
        
        var fileHandle : FileHandle? = nil
        
        let fileName = self.getFilePath(fileName: name)
        var fd : Int32 = -1
        if fileName != nil {
            
            if FileManager.default.fileExists(atPath: fileName!) && !isAppend {
                
                do {
                
                    try FileManager.default.removeItem(atPath: fileName!)
                    
                }catch {
                    
                    
                    
                }
                
            }
            
            let flags : Int32 = O_WRONLY | O_APPEND | O_CREAT
            let s = NSString.init(string: fileName!)
            
            fd = open(s.fileSystemRepresentation, flags, 0644)
            
        }
        
        if fd == -1 {
            
            fileHandle = FileHandle.init(fileDescriptor: fd, closeOnDealloc: true)
            
        }
        
        return fileHandle
    }
    
    func getFilePath(fileName : String) -> String? {
        
       let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if paths.count > 0 {
            
            return paths.first! + "/" + fileName
            
        }
        
        return nil
        
    }
    
    //MARK: - 初始化背景
    
    func initBackground() {
        
        pastelBackgroundView = PastelView()
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
    
    //MARK: - 初始化TableView
    func initTableView() {
        
        tableView = UITableView()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(120 * HeightScale)
            
            
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        
        tableView.register(MainTableCell.classForCoder(), forCellReuseIdentifier: MainTableCell.cellID)
    }
    
    //MARK: - 初始化滚动视图
    func initCollectionView() {
        
        let contentView = UIView(frame: .init(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.width * 1.1))
        self.view.addSubview(contentView)
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = ZoomInOutAttributesAnimator(scaleRate: 0.4)
        layout.scrollDirection = .horizontal
        
        
        collectionView = UICollectionView(frame: .init(x: 0, y: 18, width: contentView.frame.width, height: contentView.frame.height - 30), collectionViewLayout: layout)
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MainCollectionCell.classForCoder(), forCellWithReuseIdentifier: MainCollectionCell.cellID)
        
        contentView.addSubview(collectionView)
        
        pageControl = CHIPageControlJalapeno()
        contentView.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(contentView)
            make.top.equalTo(collectionView.snp.bottom).offset(-15 * HeightScale)
            make.width.equalTo(100 * WidthScale)
            make.height.equalTo(20 * HeightScale)
            
        }
        
        pageControl.numberOfPages = 3
        pageControl.radius = 3.5
        pageControl.currentPageTintColor = UIColor.init(r: 230, g: 230, b: 230)
        pageControl.tintColor = UIColor.textColor

        self.tableView.tableHeaderView = contentView
        
    }
    
    //MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionCell.cellID, for: indexPath) as! MainCollectionCell
        
        cell.pageImageView.image = self.images[indexPath.row]
        cell.iconImageView.image = self.icons[indexPath.row]
        cell.leftTitleLabel.text = self.titles[indexPath.row]
        
        cell.temperature = self.temps[indexPath.row]
        cell.tempLabel.text = "\(self.temps[indexPath.row])℃"
        
        cell.progress.progress = 0
        cell.progress.startAnimation(temperature: self.temps[indexPath.row])
        
        return cell
        
    }
    
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ScreenSize.width, height: ScreenSize.width * 0.99)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return .zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = self.collectionCurrentIndex
        
        return self.data[index].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableCell.cellID, for: indexPath) as! MainTableCell
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        let index = self.collectionCurrentIndex
        
        cell.titleLabel.text = self.cellTitles[index][indexPath.row]
        
        let flag = self.data[index][indexPath.row]
        
        cell.iconImageView.image = flag ? self.cellImagesOn[index][indexPath.row] : self.cellImagesOff[index][indexPath.row]
        
        cell.controlSwitch.isOn = flag
        
        if index == 2 && indexPath.row == 2 {
            
            if flag {
                
                cell.fanAnimate()
                
            }
            
        }
        
        return cell
        
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 280 * HeightScale
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            cell?.transform = .identity
            
        }, completion: nil)
        
    }
    
    //MARK: - MainTableCellDelegate
    
    func tableViewCellSwitchValueChanged(cell: MainTableCell, value: Bool) {
        
        let indexPath : IndexPath  = self.tableView.indexPath(for: cell)!
        let index = self.collectionCurrentIndex
        
        switch (index, indexPath.row) {
            
        case (0,0):
            
            if value {
                
                RMQTool.publish(message: ControlSwitch.kledon.rawValue)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.kledoff.rawValue)
            }
            cell.customAnimate()
            
            Control.share.livingRoomLight = value
            
            
            
        case (1,0):
            
            if value {
                
                RMQTool.publish(message: ControlSwitch.sledon.rawValue)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.sledoff.rawValue)
                
            }
            cell.customAnimate()
            
            Control.share.studyLight = value
            
            
        case (2,0):
            
            if value {
                
                RMQTool.publish(message: ControlSwitch.aledon.rawValue)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.aledoff.rawValue)
                
            }
            cell.customAnimate()
            
            Control.share.bedroomLightA = value
            
        case (2,1):
            
            if value {
                
                RMQTool.publish(message: ControlSwitch.bledon.rawValue)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.bledoff.rawValue)
                
            }
            cell.customAnimate()
            
            Control.share.bedroomLightB = value
            
            
        case (2,2):
            
            if value {
                
                cell.fanAnimate()
                RMQTool.publish(message: ControlSwitch.windon.rawValue)
                
            }else {
                
                cell.stopFanAnimate()
                RMQTool.publish(message: ControlSwitch.windoff.rawValue)
                
            }
            
            Control.share.fan = value
            
        case(2,3):
            
            if value {
                
                RMQTool.publish(message: ControlSwitch.winon.rawValue)
                
            }else {
                
                RMQTool.publish(message: ControlSwitch.winoff.rawValue)
                
            }
            
            cell.customAnimate()
            
            Control.share.curtain = value
            
        default:
            
            break
        }
        
        self.data[index][indexPath.row] = value
        cell.iconImageView.image = value ? self.cellImagesOn[index][indexPath.row] : self.cellImagesOff[index][indexPath.row]
        
    }
    //MARK: - Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(self.collectionView) {
            
            let x = scrollView.contentOffset.x
            
            let index = Int(x / ScreenSize.width)
            
            if collectionCurrentIndex != index {
                
                collectionCurrentIndex = index
                
                pageControl.set(progress: collectionCurrentIndex, animated: true)
                
                animate()
                
            }

        }
        
        if scrollView.isEqual(self.tableView) {
            
            
            
        }
        
    }
    
    
    func animate() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        for (index, cell) in cells.enumerated() {
            
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.2 * Double(index), options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                cell.alpha = 1
                
            }, completion: nil)
            
        }
        
    }
    
    //MARK: - 修改状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        
    }
    

    

}
