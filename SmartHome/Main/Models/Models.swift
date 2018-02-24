//
//  Models.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/15.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import Foundation
import UIKit

enum ControlSwitch : String {
    
    case kledon         //客厅灯
    case kledoff
    
    case sledon         //书房灯
    case sledoff
    
    case aledon         //卧室一灯
    case aledoff
    
    case bledon         //卧室二灯
    case bledoff
    
    case winon          //窗帘
    case winoff
    
    case windon         //风扇
    case windoff
    
    case safeon
    case safeoff
    
    case smarton
    case smartoff
    
    case home
    case sleep
    
}

class Control {
    
    var livingRoomLight : Bool = false
    
    var studyLight : Bool = false
    
    var bedroomLightA : Bool = false
    
    var bedroomLightB : Bool = false
    
    var fan : Bool = false
    
    var curtain : Bool = false
    
    var safe : Bool = false
    
    var smart : Bool  = false
    
    static let share = Control()
    
}

class Monitor {
    
    var light : Double = 23.0
    
    var smoke : Double = 2752.0
    
    var temp : Double = 23.0
    
    var hum : Double = 34.0
    
    static let now = Monitor()
    
}

