//
//  MediaListTableViewCell.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import UIKit

class MediaListTableViewCell: UITableViewCell {

    // View outlet
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var lblShowTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Bind data with UI
    func dataLoad(data: Content){
        imgView.image = UIImage(named: data.posterImage)
        lblShowTitle.text = data.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
