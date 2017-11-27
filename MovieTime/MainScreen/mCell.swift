//
//  mCell.swift
//  MMovie
//
//  Created by Archana Vetkar on 27/11/17.
//  Copyright © 2017 Archana Vetkar. All rights reserved.
//

//This is collectionview cell to display image, title and year

import UIKit

class mCell: UICollectionViewCell {
    
    @IBOutlet weak var img_movie: UIImageView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_year: UILabel!
    
    override func awakeFromNib() {
        img_movie.layer.borderWidth = 1.5;
        img_movie.layer.borderColor=UIColor.black.cgColor;
    }
    
}
