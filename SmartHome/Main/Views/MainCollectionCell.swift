//
//  MainCollectionCell.swift
//  SmartHome
//
//  Created by 王坤田 on 2017/11/10.
//  Copyright © 2017年 王坤田. All rights reserved.
//

import UIKit

class MainCollectionCell: UICollectionViewCell {
    
    var pageImageView : UIImageView!
    
    var leftButtonView : UIView!
    
    var rightButtonView : UIView!
    
    var leftTitleLabel : UILabel!
    
    var rightTitleLabel : UILabel!
    
    var temperature : Double!
    
    var tempLabel : UILabel!
    
    var iconImageView : UIImageView!
    
    var rightImageView : UIImageView!
    
    var progress : KDCircularProgress!
    
    static let cellID : String = "MainCollectionCell"
    
    //MARK: -
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化
    func initViews() {
        
        let shadowView = UIView()
        self.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(-30 * HeightScale)
            make.centerX.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            
        }
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 8, height: 8)
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 3.0
        shadowView.layer.borderColor = UIColor.clear.cgColor
        
        shadowView.clipsToBounds = false
        
        let contentView = UIView()
        shadowView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            
            make.left.right.top.bottom.equalTo(0)
            
        }
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12.0
        
        
        pageImageView = UIImageView()
        contentView.addSubview(pageImageView)
        
        pageImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.centerX.equalTo(self)
            make.height.equalTo(contentView).multipliedBy(0.54)
            make.width.equalTo(ScreenSize.width)
            
        }
        
        pageImageView.isUserInteractionEnabled = true
        

        let pageImageTap = UITapGestureRecognizer(target: self, action: #selector(pageImageViewTapped(sender:)))
        
        pageImageView.addGestureRecognizer(pageImageTap)
        
        
        leftButtonView = UIView()
        contentView.addSubview(leftButtonView)
        
        leftButtonView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(pageImageView.snp.bottom).offset(-5 * HeightScale)
            make.width.equalTo(contentView).dividedBy(2.0)
            
        }
        leftButtonView.backgroundColor = UIColor.leftButtonColor
        
        rightButtonView = UIView()
        contentView.addSubview(rightButtonView)
        
        rightButtonView.snp.makeConstraints { (make) in
            
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(pageImageView.snp.bottom).offset(-5 * HeightScale)
            make.width.equalTo(contentView).dividedBy(2.0)
            
        }
        rightButtonView.backgroundColor = UIColor.rightButtonColor
        
        leftTitleLabel = UILabel()
        leftButtonView.addSubview(leftTitleLabel)
        
        leftTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(25 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        
        leftTitleLabel.textColor = UIColor.textColor
        leftTitleLabel.font = UIFont.chineseTextFont(with: 16)
        
        rightTitleLabel = UILabel()
        rightButtonView.addSubview(rightTitleLabel)
        
        rightTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(25 * WidthScale)
            make.top.equalTo(20 * HeightScale)
            
        }
        //rightTitleLabel.text = "TEMP."
        rightTitleLabel.text = "温度"
        rightTitleLabel.textColor = UIColor.textColor
        //rightTitleLabel.font = UIFont.textFont(with: 16)
        rightTitleLabel.font = UIFont.chineseTextFont(with: 16)
        
        
        progress = KDCircularProgress()
        rightButtonView.addSubview(progress)
        
        progress.snp.makeConstraints { (make) in
            
            make.center.equalTo(rightButtonView)
            make.height.width.equalTo(rightButtonView.snp.height).multipliedBy(0.6)
            
        }
        progress.startAngle = -90
        progress.progressThickness = 0.15
        progress.trackThickness = 0.15
        progress.clockwise = true
        progress.gradientRotateSpeed = 0
        progress.roundedCorners = true
        progress.glowAmount = 0.5
        progress.glowMode = .reverse
        progress.trackColor = UIColor(red: 0.247, green: 0.302, blue: 0.310, alpha: 1.000)
        
        rightImageView = UIImageView()
        progress.addSubview(rightImageView)
        
        rightImageView.snp.makeConstraints { (make) in
            
            make.center.equalTo(progress)
            make.height.width.equalTo(progress).multipliedBy(0.22)
            
        }
        rightImageView.image = #imageLiteral(resourceName: "ic_temp")
        rightImageView.isUserInteractionEnabled = true
        
        tempLabel = UILabel()
        rightButtonView.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(rightButtonView)
            make.top.equalTo(progress.snp.bottom).offset(10 * HeightScale)
            
        }
        tempLabel.text = "\(temperature)℃"
        tempLabel.textColor = UIColor.textColor
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.textFont(with: 14)
        
        let rightButtonViewTap = UITapGestureRecognizer(target: self, action: #selector(rightButtonViewTapped(sender:)))
        
        rightButtonView.addGestureRecognizer(rightButtonViewTap)
        
        iconImageView = UIImageView()
        leftButtonView.addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            
            make.center.equalTo(leftButtonView)
            make.height.width.equalTo(leftButtonView).multipliedBy(0.4)
            
        }
        iconImageView.image = #imageLiteral(resourceName: "ic_sofa")
        
    }
    
    
    @objc func pageImageViewTapped(sender : UITapGestureRecognizer) {
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.pageImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
        }, completion: { finished  in
            
            if finished {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    
                    self.pageImageView.transform = .identity
                    
                }, completion: nil)
                
                
            }
            
            
        })
        
    }
    
    @objc func rightButtonViewTapped(sender : UITapGestureRecognizer) {
        
        
        self.progress.progress = 0
        
        self.progress.startAnimation(temperature: self.temperature)
        
        self.rightImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.progress.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            self.rightImageView.transform = .identity
            self.progress.transform = .identity
            
        }, completion: nil)
        
    }
    
}

extension KDCircularProgress {
    
    func startAnimation(temperature : Double) {
        
        var colors : [UIColor] = []
        
        if temperature > 35 {
            
            colors = [.yellow,.orange,.red]
            
        }else if temperature > 20 {
            
            colors = [.yellow,.orange]
            
        }else {
            
            colors = [.cyan,.yellow]
            
        }
        
        self.set(colors: colors)
        
        
        let codeTimer = DispatchSource.makeTimerSource(queue:      DispatchQueue.global())
        
        codeTimer.schedule(deadline: .now() + 0.2, repeating: 0.01)
        
        
        codeTimer.setEventHandler(handler: {
            
            if self.progress >= temperature / 40 {
                
                codeTimer.cancel()
            }
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                
                self.progress += 0.01
                
            }
        })
        // 启动时间源
        codeTimer.resume()
        
    }
    
}
