//
//  CarousalViewCollectionViewCell.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import UIKit

class CarousalViewCollectionViewCell: UICollectionViewCell {
    
    // ImageView outlet
    @IBOutlet private weak var imgView: UIImageView!
 
    // Bind data with UI
    func setupCell(data: Content) {
        imgView.image = UIImage(named: data.posterImage)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 0
    }
}
