//
//  LoadingTableViewCell.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 11/10/2021.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

//    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
