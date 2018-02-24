//
//  ControlCollectionCell.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/16.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

class ControlCollectionCell: UICollectionViewCell {
    
    
    var titleLabel : UILabel!
    
    var iconImageView : UIImageView!
    
    var detailLabel : UILabel!
    
    static let cellID : String = "ControlCollectionCell"
    
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
        content.backgroundColor = UIColor.leftButtonColor
        
        titleLabel = UILabel()
        content.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(20 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        
        titleLabel.textColor = UIColor.textColor
        titleLabel.font = UIFont.chineseTextFont(with: 14)
        
        iconImageView = UIImageView()
        content.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(content)
            make.height.width.equalTo(80 * HeightScale)
            make.left.equalTo(65 * WidthScale)
            
        }
        
        
        detailLabel = UILabel()
        content.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(content)
            make.right.equalTo(-30 * WidthScale)
            
            
        }
        detailLabel.textColor = UIColor.textColor
        detailLabel.textAlignment = .right
        detailLabel.text = "123"
        
    }
    
}
