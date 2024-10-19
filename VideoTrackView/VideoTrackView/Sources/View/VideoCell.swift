//
//  VideoCell.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/20/24.
//

import UIKit

final class VideoCell: UICollectionViewCell {
    
    static let identifier = String(describing: VideoCell.self)
    
    private var thumbnailStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.2
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(thumbnailStackView)
        thumbnailStackView
            .widthAnchor(contentView.widthAnchor)
            .heightAnchor(contentView.heightAnchor)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(thumbnails: [CGImage]) {
        
        for thumbnail in thumbnails {
            let imageView = UIImageView(image: UIImage(cgImage: thumbnail))
            thumbnailStackView.addArrangedSubview(imageView)
        }
        
    }
    
}
