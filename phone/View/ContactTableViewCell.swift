//
//  ContactTableViewCell.swift
//  phone
//
//  Created by Aliya Dekelbayeva on 06.12.2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactTableViewCell: UILabel!
    
    static let identifier: String = "ContactTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contactTableViewCell.text = nil
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
