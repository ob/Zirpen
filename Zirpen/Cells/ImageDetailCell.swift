//
//  ImageDetailCell.swift
//  Zirpen
//
//  Created by Oscar Bonilla on 9/29/17.
//  Copyright © 2017 Oscar Bonilla. All rights reserved.
//

import UIKit

class ImageDetailCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    var photoURL: URL? {
        didSet {
            photoImageView.clipsToBounds = true
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.setImageWith(photoURL!)
        }
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
