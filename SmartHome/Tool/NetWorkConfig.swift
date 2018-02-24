//
//  NetWorkConfig.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/14.
//  Copyright © 2017年 王坤田. All rights reserved.
//
import UIKit
import Foundation

class NetWork {
    
    var ip : String = "192.168.49.100"
    
    var port : String = "8080"
    
    var projectName : String = "/SmartHomeServer"
    
    var server : String {
        
        get {
            
            return "http://" + ip + ":" + port + projectName
            
        }
        
    }
    
    var sendControl : String {
        
        get {
            
            return server + "/PutControlServlet"
            
        }
        
    }
    
    var getControl : String  {
        
        get {
            
            return server + "/GetControlServlet"
            
        }
    }
    
    var getMonitor : String {
        
        get {
            
            return server + "/GetMonitorServlet"
            
        }
        
    }
    
    static let share = NetWork()
  
}
