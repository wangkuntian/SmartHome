//
//  RobotSpeechTableCell.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/17.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

class RobotSpeechTableCell: UITableViewCell {
    
    var titleLabel : UILabel!
    
    static let cellID : String = "RobotSpeechTableCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
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
            
            make.left.equalTo(20 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            make.width.equalTo(self.contentView).multipliedBy(0.75)
            make.height.equalTo(self.contentView).multipliedBy(0.9)
            
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
            
            make.left.equalTo(35 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        titleLabel.text = "Light"
        titleLabel.textColor = UIColor.textColor
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
