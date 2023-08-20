//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Monica Qiu on 8/19/23.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.height,
            height: contentView.height
        )
        
        titleLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15, // 10 on left, 5 on right
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
        titleLabel.text = viewModel.title
        
    }

}
