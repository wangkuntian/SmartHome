//
//  SideMenuCollectionCell.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/15.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

class SideMenuCollectionCell: UICollectionViewCell {
    
    
    var titleLabel : UILabel!
    
    var iconImageView : UIImageView!
    
    static let cellID : String = "SideMenuCollectionCell"
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化
    func initViews() {
        
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        let shadowView = UIView()
        self.contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.95)
            make.height.equalTo(self.contentView).multipliedBy(0.95)
            
        }
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 3.0
        shadowView.layer.borderColor = UIColor.clear.cgColor
        
        shadowView.clipsToBounds = false
        
        let content = UIView()
        shadowView.addSubview(content)
        
        content.snp.makeConstraints { (make) in
            
            make.left.right.top.bottom.equalTo(0)
            
        }
        
        content.layer.masksToBounds = true
        content.layer.cornerRadius = 12.0
        content.backgroundColor = UIColor.cellColor
        
        titleLabel = UILabel()
        content.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(20 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        titleLabel.text = "Light"
        titleLabel.textColor = UIColor.textColor
        titleLabel.font = UIFont.chineseTextFont(with: 14)
        
        iconImageView = UIImageView()
        content.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            
            make.center.equalTo(content)
            make.height.width.equalTo(80 * HeightScale)
            
        }
        
        
    }
    
    
}
