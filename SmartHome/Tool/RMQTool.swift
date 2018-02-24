//
//  RMQTool.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/14.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import Foundation
import RMQClient
import SCLAlertView
import AVFoundation

class RMQConfig {
    
    var ip : String = "192.168.49.89"
    
    var port : String = "5672"
    
    var username : String = "test"
    
    var password : String = "123"
    
    var virtualHost : String = "teathost"
    
    var url : String {
        
        get {
            
            return "amqp://\(username):\(password)@\(ip):\(port)/\(virtualHost)"
            
        }
        
    }
    
    var exchangeName : String = "amq.fanout"
    
    var routingKey : String = "chat"
    
    static let share = RMQConfig()
    
}

struct RMQTool {
    
    static var connection : RMQConnection!
    static var channel : RMQChannel!
    static var exchange : RMQExchange!
    static var player : AVAudioPlayer!
    
    
    static func subscribe() {
        
        let delegate = RMQConnectionDelegateLogger()
        connection = RMQConnection(uri: RMQConfig.share.url, delegate: delegate)
        connection.start()
        
        channel = connection.createChannel()
        
        channel.basicQos(1, global: true)
        
        let queue : RMQQueue = channel.queue("", options: RMQQueueDeclareOptions.durable)
        
        exchange = channel.fanout(RMQConfig.share.exchangeName, options: .durable)
        
        queue.bind(exchange, routingKey: RMQConfig.share.routingKey)

        queue.subscribe({ m in
            
            let result : String =  String.init(data: m.body, encoding: String.Encoding.utf8)!
            
            print("Received: \(result)")
            
            if result.hasPrefix("Smog") {
                
                let s = result.substring(from: 4)
                let data : Double = Double(s)!
                
                if Monitor.now.smoke != data {
                    
                    Monitor.now.smoke = data
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "Smog")))
                        
                    }
                    
                }
                
                
                
            }else if result.hasPrefix("Light") {
                
                let s = result.substring(from: 5)
                let data : Double = Double(s)!
                
                if Monitor.now.light != data {
                    
                    Monitor.now.light = data
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "Light")))
                    }
                    
                }
                
                
                
            }else if result.hasPrefix("Temp") {
                
                let s = result.substring(from: 4)
                let data : Double = Double(s)!
                
                if Monitor.now.light != data {
                    
                    Monitor.now.temp = data
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "Temp")))
                    }
                    
                }
                
                
                
            }else if result.hasPrefix("Hum") {
                
                let s = result.substring(from: 3)
                let data : Double = Double(s)!
                
                if Monitor.now.hum != data {
                    
                    Monitor.now.hum = data
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(rawValue: "Hum")))
                    }
                }
                
            }else if result.elementsEqual("smodbody") {
                
                DispatchQueue.main.async {
                    
                    let appearance = SCLAlertView.SCLAppearance(
                        
                        kDefaultShadowOpacity : 0.1,
                        showCloseButton: true,
                        shouldAutoDismiss : false,
                        hideWhenBackgroundViewIsTapped : false
                        
                    )
                    
                    do {
                        
                        let session = AVAudioSession.sharedInstance()
                        
                        try session.setCategory(AVAudioSessionCategoryPlayback)
                        try session.setActive(true)
                        
                        
                        let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
                        
                        player = try AVAudioPlayer.init(contentsOf: url!)
                        
                        player.prepareToPlay()
                        
                        player.play()
                        
                    }catch {
                        
                        print("error")
                        
                    }
                    
                    let alert = SCLAlertView(appearance: appearance)
                    alert.showWarning("警告！", subTitle: "有非法入侵！", closeButtonTitle: "OK",animationStyle: SCLAnimationStyle.bottomToTop)
                    
                }
                
            }
            
        })
        
        
    }
    
    static func publish(message : String) {
        
        exchange.publish(message.data(using: .utf8), routingKey: RMQConfig.share.routingKey)
        
    }
    
}
