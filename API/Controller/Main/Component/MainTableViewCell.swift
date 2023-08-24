//
//  MainTableViewCell.swift
//  API
//
//  Created by imac-1682 on 2023/8/16.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Wx: UILabel!
    @IBOutlet weak var Area: UILabel!
    @IBOutlet weak var MaxT: UILabel!
    @IBOutlet weak var MinT: UILabel!
    @IBOutlet weak var CI: UILabel!
    @IBOutlet weak var PoP: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var MaxTLabel: UILabel!
    @IBOutlet weak var MinTLabel: UILabel!
    @IBOutlet weak var CILabel: UILabel!
    @IBOutlet weak var PoPLabel: UILabel!
    
    
    static let identifier = "MainTableViewCell"

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocationUI()
        setMaxTUI()
        setMinTUI()
        setCIUI()
        setPoPUI()

        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLocationUI() {
        
        let content = NSMutableAttributedString(string: "")
        let Attachment = NSTextAttachment()
        Attachment.image = UIImage(named: "paperplane")
        Attachment.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        content.append(NSAttributedString(attachment: Attachment))
        content.append(NSAttributedString(string: " 地點"))
        location.numberOfLines = 0
        location.attributedText = content
    }
    
    func setMaxTUI() {
        let content = NSMutableAttributedString(string: "")
        let Attachment = NSTextAttachment()
        Attachment.image = UIImage(named: "thermometer.high")
        Attachment.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        content.append(NSAttributedString(attachment: Attachment))
        content.append(NSAttributedString(string: " 最高溫度"))
        MaxTLabel.numberOfLines = 0
        MaxTLabel.attributedText = content
    }
    
    func setMinTUI() {
        let content = NSMutableAttributedString(string: "")
        let Attachment = NSTextAttachment()
        Attachment.image = UIImage(named: "thermometer.low")
        Attachment.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        content.append(NSAttributedString(attachment: Attachment))
        content.append(NSAttributedString(string: " 最低溫度"))
        MinTLabel.numberOfLines = 0
        MinTLabel.attributedText = content
    }
    
    func setCIUI() {
        let content = NSMutableAttributedString(string: "")
        let Attachment = NSTextAttachment()
        Attachment.image = UIImage(named: "leaf")
        Attachment.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        content.append(NSAttributedString(attachment: Attachment))
        content.append(NSAttributedString(string: " 舒適度"))
        CILabel.numberOfLines = 0
        CILabel.attributedText = content
    }
    
    func setPoPUI() {
        let content = NSMutableAttributedString(string: "")
        let Attachment = NSTextAttachment()
        Attachment.image = UIImage(named: "cloud.rain")
        Attachment.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        content.append(NSAttributedString(attachment: Attachment))
        content.append(NSAttributedString(string: " 降雨機率"))
        PoPLabel.numberOfLines = 0
        PoPLabel.attributedText = content
    }
}
