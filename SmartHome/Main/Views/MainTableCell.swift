//
//  MainTableCell.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/9.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

protocol  MainTableCellDelegate {
    
    func tableViewCellSwitchValueChanged(cell : MainTableCell, value : Bool)
    
}

class MainTableCell: UITableViewCell {
    
    var titleLabel : UILabel!
    
    var iconImageView : UIImageView!
    
    var controlSwitch : UISwitch!
    
    var delegate : MainTableCellDelegate?
    
    static let cellID : String = "MainTableCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            
            make.center.equalTo(self.contentView)
            make.width.equalTo(self.contentView).multipliedBy(0.9)
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
            
            make.left.equalTo(25 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        titleLabel.text = "Light"
        titleLabel.textColor = UIColor.textColor
        titleLabel.font = UIFont.textFont(with: 16)
        
        iconImageView = UIImageView()
        content.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(content)
            make.left.equalTo(titleLabel).offset(80 * WidthScale)
            make.height.width.equalTo(95 * HeightScale)
            
        }
        iconImageView.image = #imageLiteral(resourceName: "ic_light_off")
        
        controlSwitch = UISwitch()
        content.addSubview(controlSwitch)
        
        controlSwitch.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(content)
            make.right.equalTo(content).offset(-60 * WidthScale)            
        }
        controlSwitch.tintColor = UIColor.textColor
        controlSwitch.onTintColor = UIColor.init(r: 26, g: 250, b:  50)
        controlSwitch.thumbTintColor = UIColor.textColor
        controlSwitch.addTarget(self, action: #selector(lightSwitchChanged(sender:)), for: .valueChanged)
        
        
        
    }
    
    @objc func lightSwitchChanged (sender : UISwitch) {
        
        delegate?.tableViewCellSwitchValueChanged(cell: self, value: sender.isOn)
        
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

extension MainTableCell {
    
    func customAnimate() {
        
        controlSwitch.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        iconImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            
            self.controlSwitch.transform = .identity
            self.iconImageView.transform = .identity
            
            
        }, completion: nil)
        
    }
    
    func fanAnimate() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn,.repeat], animations: {
            
            self.iconImageView.transform = self.iconImageView.transform.rotated(by: CGFloat(Double.pi / 4))
            
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear,.repeat], animations: {
                
                self.iconImageView.transform = self.iconImageView.transform.rotated(by: CGFloat(Double.pi / 2))
                
            }, completion: nil)
            
        }
        
        
    }
    
    func stopFanAnimate() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                
                self.iconImageView.transform = self.iconImageView.transform.rotated(by: CGFloat(Double.pi / 3))
                
            }, completion: nil)
            
            
        }
        
    }
    
}
