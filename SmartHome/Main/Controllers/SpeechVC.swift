//
//  SpeechVC.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/17.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit
import Pastel
import AVFoundation
import SwiftyJSON
import NVActivityIndicatorView

class SpeechVC: UIViewController,UITableViewDelegate, UITableViewDataSource,IFlySpeechSynthesizerDelegate, IFlySpeechRecognizerDelegate{
    
    
    
    var tableView : UITableView!
    
    var voiceImageView : UIImageView!
    
    var robots : [String] = ["您好，鲁东大学的小月为您服务"]
    
    var isRobot : [Bool] = [true]

    var users : [String] = [""]
    
    var speech : String = ""
    
    var iFlySpeechSynthesizer : IFlySpeechSynthesizer!
    
    var iFlySpeechRecognizer : IFlySpeechRecognizer!
    
    var activityIndicatorView : NVActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        config()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initViews()
        
        
    }
    
    //MARK:- 初始化界面
    func initViews() {
        
        initNavBar()
        
        initBackground()
        
        initTableView()
        
        initVoiceImageView()

    }
    
    //MARK:-
    func config() {
        
        iFlySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()
        iFlySpeechSynthesizer.delegate = self
        
        iFlySpeechSynthesizer.setParameter(IFlySpeechConstant.type_CLOUD(), forKey: IFlySpeechConstant.engine_TYPE())
        
        iFlySpeechSynthesizer.setParameter("50", forKey: IFlySpeechConstant.volume())
        iFlySpeechSynthesizer.setParameter("", forKey: IFlySpeechConstant.tts_AUDIO_PATH())
        
        iFlySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()
        iFlySpeechRecognizer.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        iFlySpeechRecognizer.setParameter("", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        iFlySpeechRecognizer.delegate = self
        
        iFlySpeechSynthesizer.startSpeaking(self.robots.first!)
        
    }
    
    //MARK: - 初始化导航栏
    func initNavBar() {
        
        let navigationBar : UINavigationBar = (self.navigationController?.navigationBar)!
        
        let frame = navigationBar.frame
        
        navigationBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + 10 * HeightScale)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.textFont(with: 20)!,NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(disMiss))
        let rightBarButton = UIBarButtonItem.createBarButtonItem(with: #imageLiteral(resourceName: "ic_close"), and: rightTap)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
    }
    //MARK: - 关闭视图
    @objc func disMiss() {
        
        if self.iFlySpeechSynthesizer.isSpeaking {
            
            self.iFlySpeechSynthesizer.stopSpeaking()
            
        }
        
        if self.iFlySpeechRecognizer.isListening {
            
            self.iFlySpeechRecognizer.cancel()
            
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //MARK: - 初始化背景
    
    func initBackground() {
        
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
    
    //MARK: - 初始化TableView
    func initTableView() {
        
        tableView = UITableView()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(0)
            make.bottom.equalTo(-170 * HeightScale)
            make.top.equalTo(120 * HeightScale)
            
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        
        tableView.register(RobotSpeechTableCell.classForCoder(), forCellReuseIdentifier: RobotSpeechTableCell.cellID)
        tableView.register(UserSpeechTableCell.classForCoder(), forCellReuseIdentifier: UserSpeechTableCell.cellID)
    }
    
    //MARK: - 初始化VoiceImageView
    func initVoiceImageView() {
        
        let content = UIView()
        self.view.addSubview(content)
        
        content.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(-20 * HeightScale)
            make.centerX.equalTo(self.view)
            make.height.width.equalTo(110 * HeightScale)
            
        }
        
        content.layer.shadowColor = UIColor.black.cgColor
        content.layer.shadowOffset = CGSize(width: 3, height: 3)
        content.layer.shadowOpacity = 0.5
        content.layer.shadowRadius = 3.0
        content.clipsToBounds = false
        
        voiceImageView = UIImageView()
        content.addSubview(voiceImageView)
        
        voiceImageView.snp.makeConstraints { (make) in
            
            make.left.right.bottom.top.equalTo(0)
            
        }
        voiceImageView.image = #imageLiteral(resourceName: "ic_speech_off")
        voiceImageView.layer.cornerRadius = 30 * HeightScale
        voiceImageView.layer.masksToBounds = true
        voiceImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(speechStart))
        voiceImageView.addGestureRecognizer(tap)
        
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 100 * HeightScale, height: 35 * HeightScale), type: NVActivityIndicatorType.lineScalePulseOut, color: UIColor.white, padding: nil)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(voiceImageView).offset(-75 * HeightScale)
            make.centerX.equalTo(voiceImageView)
            
            
        }
        
    }
    
    @objc func speechStart() {
        
        
        
        if self.iFlySpeechSynthesizer.isSpeaking {
            
            self.iFlySpeechSynthesizer.stopSpeaking()
        }
        
        if self.iFlySpeechRecognizer.isListening {
            
            self.iFlySpeechRecognizer.stopListening()
            self.voiceImageView.image = #imageLiteral(resourceName: "ic_speech_off")
            self.activityIndicatorView.stopAnimating()
            return
        }
        
        self.voiceImageView.image = #imageLiteral(resourceName: "ic_speech_on")
        self.voiceImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            
            self.voiceImageView.transform = .identity
            
        }, completion: nil)
        
        iFlySpeechRecognizer.startListening()
        activityIndicatorView.startAnimating()
        
    }
    
    //MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isRobot.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        if self.isRobot[index] {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RobotSpeechTableCell.cellID, for: indexPath) as! RobotSpeechTableCell
            cell.titleLabel.text = self.robots[index]
            
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UserSpeechTableCell.cellID, for: indexPath) as! UserSpeechTableCell
            cell.titleLabel.text = self.users[index]
            
            return cell
            
            
        }
        
        
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200 * HeightScale
        
    }
     //MARK: - IFlySpeechRecognizer Delegate
    func onError(_ errorCode: IFlySpeechError!) {
        
        print(errorCode.description)
        
    }
    
    func onResults(_ results: [Any]!, isLast: Bool) {
        
        
        if results == nil {
            
            return
            
        }
        
        let dic : Dictionary<String,String> = results[0] as! Dictionary
        
        var temp : String = ""
        
        var result : String = ""
        
        for key in dic.keys {
            
            temp.append(key)
            
            let data : Data = temp.data(using: String.Encoding.utf8)!
            
            let json = JSON.init(data)
            let array = json["ws"].array
            
            for item in array! {
                
                let s : String = item["cw"][0]["w"].string!
                
                result += s
                
            }
        }
        
        self.speech.append(result)
        
        if isLast {
            
            self.activityIndicatorView.stopAnimating()
            self.voiceImageView.image = #imageLiteral(resourceName: "ic_speech_off")
            
            self.robots.append("")
            self.users.append(self.speech)
            self.isRobot.append(false)
            
            let indexPath : IndexPath = IndexPath.init(row: self.isRobot.count - 1, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            
            handle(result: self.speech)
            
            self.speech = ""
            
        }
        
    }
    
    
    func handle(result : String) {
        
        var speak : String = ""
        
        var data : String = ""
        
        if result.contains("客厅") {
            
            if !result.contains("不") {
                
                if result.contains("打开") && result.contains("灯"){
                    
                    data = "正在打开客厅的灯,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开客厅的灯"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.kledon.rawValue)
                    Control.share.livingRoomLight = true
                    
                    speak = "已打开"
                    
                    self.addRow(message: speak)
                    return
                    
                }else if result.contains("关闭") && result.contains("灯") {
                    
                    data = "正在关闭客厅的灯,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭客厅的灯"
                    self.addRow(message: speak)
                    
                    
                    RMQTool.publish(message: ControlSwitch.kledoff.rawValue)
                    Control.share.livingRoomLight = false
                    speak = "已关闭"
                    
                    self.addRow(message: speak)
                    return
                }
                
            }
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
        }
        if result.contains("卧室") {
            
            if !result.contains("不") {
                
                if result.contains("打开") && result.contains("风扇") {
                    
                    data = "正在打开卧室的风扇,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开卧室的风扇"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.windon.rawValue)
                    Control.share.fan = true
                    
                    speak = "已打开"
                    self.addRow(message: speak)
                    return
                    
                    
                }else if result.contains("关闭") && result.contains("风扇") {
                    
                    data = "正在关闭卧室的风扇,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭卧室的风扇"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.windoff.rawValue)
                    Control.share.fan = false
                    
                    speak = "已关闭"
                    self.addRow(message: speak)
                    return
                    
                }
                
                if result.contains("打开") && result.contains("灯"){
                    
                    data = "正在打开卧室的灯,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开卧室的灯"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.aledon.rawValue)
                    RMQTool.publish(message: ControlSwitch.bledon.rawValue)
                    
                    Control.share.bedroomLightA = true
                    Control.share.bedroomLightB = true
                    
                    speak = "已打开"
                    self.addRow(message: speak)
                    
                    return
                    
                    
                }else if result.contains("关闭") && result.contains("灯") {
                    
                    data = "正在关闭卧室的灯,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭卧室的灯"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.aledoff.rawValue)
                    RMQTool.publish(message: ControlSwitch.bledoff.rawValue)
                    
                    Control.share.bedroomLightA = false
                    Control.share.bedroomLightB = false
                    
                    speak = "已关闭"
                    self.addRow(message: speak)
                    return
                    
                }
                
            }
            
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            return
            
        }
        
        if result.contains("书房") {
            
            if !result.contains("不") {
                
                if result.contains("打开") && result.contains("灯"){
                    
                    data = "正在打开书房的灯,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开书房的灯"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.sledon.rawValue)
                    Control.share.studyLight = true
                    
                    speak = "已打开"
                    self.addRow(message: speak)
                    
                    return
                    
                    
                }else if result.contains("关闭") && result.contains("灯") {
                    
                    data = "正在关闭书房的灯,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭书房的灯"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.sledoff.rawValue)
                    Control.share.studyLight = false
                    
                    speak = "已关闭"
                    self.addRow(message: speak)
                    return
                    
                }
                
            }
            
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
            
        }
        
        if result.contains("风扇") {
            
            if !result.contains("不") {
                
                if result.contains("打开") {
                    
                    data = "正在打开风扇,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开风扇"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.windon.rawValue)
                    Control.share.fan = true
                    
                    speak = "已打开"
                    self.addRow(message: speak)
                    return
                    
                    
                }else if result.contains("关闭") {
                    
                    data = "正在关闭风扇,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭风扇"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.windoff.rawValue)
                    Control.share.fan = false
                    
                    speak = "已关闭"
                    self.addRow(message: speak)
                    return
                    
                    
                }
                
            }
            
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
            
        }
        
        if result.contains("窗帘") {
            
            if !result.contains("不") {
                
                if result.contains("打开") {
                    
                    data = "正在打开窗帘,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    speak = "正在打开窗帘"
                    
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.winon.rawValue)
                    Control.share.curtain = true
                    
                    speak = "已打开"
                    self.addRow(message: speak)
                    return
                    
                    
                }else if result.contains("关闭") {
                    
                    data = "正在关闭窗帘,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    speak = "正在关闭窗帘"
                    
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.winoff.rawValue)
                    Control.share.curtain = false
                    
                    speak = "已关闭"
                    self.addRow(message: speak)
                    return
                    
                }
                
            }
            
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
            
        }
        
        if result.contains("安全") || result.contains("安防") {
            
            if !result.contains("不") {
                
                if result.contains("打开") || result.contains("启动") {
                    
                    data = "正在打开安防模式,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开安防模式"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.safeon.rawValue)
                    Control.share.livingRoomLight = true
                    
                    speak = "已打开"
                    
                    self.addRow(message: speak)
                    return
                    
                }else if result.contains("关闭") {
                    
                    data = "正在关闭安防模式,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭安防模式"
                    self.addRow(message: speak)
                    
                    
                    RMQTool.publish(message: ControlSwitch.safeoff.rawValue)
                    Control.share.livingRoomLight = false
                    speak = "已关闭"
                    
                    self.addRow(message: speak)
                    return
                }
                
            }
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
        }
        
        if result.contains("智能") {
            
            if !result.contains("不") {
                
                if result.contains("打开") || result.contains("启动") {
                    
                    data = "正在打开智能模式,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开智能模式"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.smarton.rawValue)
                    Control.share.livingRoomLight = true
                    
                    speak = "已打开"
                    
                    self.addRow(message: speak)
                    return
                    
                }else if result.contains("关闭") {
                    
                    data = "正在关闭智能模式,已关闭"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在关闭智能模式"
                    self.addRow(message: speak)
                    
                    
                    RMQTool.publish(message: ControlSwitch.smartoff.rawValue)
                    Control.share.livingRoomLight = false
                    speak = "已关闭"
                    
                    self.addRow(message: speak)
                    return
                }
                
            }
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
        }
        
        if result.contains("家居") || result.contains("居家") {
            
            if !result.contains("不") {
                
                if result.contains("打开") || result.contains("启动") {
                    
                    data = "正在打开家居模式,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开家居模式"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.home.rawValue)
                    
                    speak = "已打开"
                    
                    self.addRow(message: speak)
                    return
                    
                }
                
            }
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
        }
        
        if result.contains("睡眠") {
            
            if !result.contains("不") {
                
                if result.contains("打开") || result.contains("启动") {
                    
                    data = "正在打开睡眠模式,已打开"
                    self.iFlySpeechSynthesizer.startSpeaking(data)
                    
                    speak = "正在打开睡眠模式"
                    self.addRow(message: speak)
                    
                    RMQTool.publish(message: ControlSwitch.sleep.rawValue)
                    
                    speak = "已打开"
                    
                    self.addRow(message: speak)
                    return
                    
                }
                
            }
            speak = "对不起，我不是很明白"
            self.iFlySpeechSynthesizer.startSpeaking(speak)
            self.addRow(message: speak)
            
            return
        }
        
        speak = "对不起，我不是很明白"
        self.iFlySpeechSynthesizer.startSpeaking(speak)
        self.addRow(message: speak)
        
        
    }
    
    func addRow(message : String) {
        
        self.isRobot.append(true)
        self.robots.append(message)
        self.users.append("")
        let indexPath : IndexPath = IndexPath.init(row: self.isRobot.count - 1, section: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
    
    //MARK: - IFlySpeechSynthesizer Delegate
    func onCompleted(_ error: IFlySpeechError!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

}
