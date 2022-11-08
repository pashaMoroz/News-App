//
//  ArticleCell.swift
//  News App
//
//  Created by Admin on 07/11/2022.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder


//source, author, title, description and image with urlToImage

class ArticleCell: UITableViewCell {
    
    // MARK: - Properties
    
    var articleInfo: ArticleInfo! {
        didSet {
            configureArticleInfo()
        }
    }
    
    private let acticleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "newspaper")
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .systemGray
        iv.clipsToBounds =  true
        return iv
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

extension ArticleCell {
    
    private func setupCell() {
        backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [sourceLabel, authorLabel])
        addSubview(stack)
        
        addSubview(acticleImageView)
        addSubview(descriptionLabel)
        addSubview(titleLabel)
        
        let dimensionsImg = CGFloat(110)
        acticleImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 8)
        acticleImageView.setDimensions(height: dimensionsImg, width: dimensionsImg)
        acticleImageView.layer.cornerRadius = dimensionsImg / 2
        
        
        titleLabel.anchor(top: topAnchor,
                          left: acticleImageView.rightAnchor,
                          right: rightAnchor,
                          paddingTop: 3,
                          paddingLeft: 5,
                          paddingRight: 5)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                left: acticleImageView.rightAnchor,
                                right: rightAnchor,
                                paddingTop: 5,
                                paddingLeft: 10,
                                paddingBottom: 5,
                                paddingRight: 10)
        
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillProportionally
        stack.alignment = .center
        
        stack.anchor(top: descriptionLabel.bottomAnchor,
                     left: acticleImageView.rightAnchor,
                     bottom: bottomAnchor,
                     right: rightAnchor,
                     paddingTop: 5,
                     paddingLeft: 8,
                     paddingBottom: 3,
                     paddingRight: 5)
    }
    
    private func configureArticleInfo() {
        
        sourceLabel.text = articleInfo.source?.name ?? ""
        authorLabel.text = articleInfo.author ?? ""
        titleLabel.text =  articleInfo.title ?? ""
        descriptionLabel.text = articleInfo.description ?? ""
        
        guard let urlToImage = articleInfo.urlToImage else { return }
        guard let url = URL(string: urlToImage) else { return }
        acticleImageView.sd_setImage(with: url)
    }
}
