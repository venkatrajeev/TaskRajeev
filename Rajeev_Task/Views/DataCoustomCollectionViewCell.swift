//
//  DataCoustomCollectionViewCell.swift
//  Rajeev_Task
//
//  Created by Gemini on 7/25/18.
//  Copyright © 2018 Gemini. All rights reserved.
//

import Foundation
import UIKit

class DataCoustomCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.numberOfLines=0;
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let showCaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(named: "noImageicon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    func addViews(){
        backgroundColor = UIColor.white
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(showCaseImageView)
        
        // Set Constraints to views
        
        // for title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: 25).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                            constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                             constant: 5).isActive = true
        // for Description label
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.readableContentGuide.bottomAnchor,
                                              constant: 15).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                  constant: 5).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                   constant: 5).isActive = true
        // For showCaseImageView ImageView
        showCaseImageView.topAnchor.constraint(equalTo: descriptionLabel.readableContentGuide.bottomAnchor,
                                               constant: 20).isActive = true
        showCaseImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                  constant: 20).isActive = true
        
        showCaseImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: 5).isActive = true
        showCaseImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: 5).isActive = true
        
        showCaseImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
