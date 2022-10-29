//
//  OTPCell.swift
//  2FA iOS App
//
//  Created by Miguel Angel Castellanos Salamanca on 27/10/22.
//

import UIKit

class OTPCell: UITableViewCell {

    @IBOutlet weak var contentBubble: UIView!
    @IBOutlet weak var issuerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var OTPLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentBubble.layer.cornerRadius = contentBubble.frame.size.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
