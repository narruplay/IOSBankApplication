//
//  TableCustomCell.swift
//  MasterDetailTestProject
//
//  Created by Adel Khaziakhmetov on 15.01.17.
//  Copyright © 2017 Adel Khaziakhmetov. All rights reserved.
//

import UIKit

class TableCustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        self.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
