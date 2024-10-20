//
//  VideoCell.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/20/24.
//

import UIKit

final class VideoCell: UICollectionViewCell {

    private let thumbnailStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.2
        return stackView
    }()
    
    private let durationLabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        return label
    }()
    
    private let blackOpacityView = {
        let view = UIView()
        
        view.backgroundColor = .black.withAlphaComponent(0.2)
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    private func configureHierarchy() {
        contentView.addSubview(thumbnailStackView)
        contentView.addSubview(blackOpacityView)
        contentView.addSubview(durationLabel)
    }
    
    private func configureLayout() {
        thumbnailStackView
            .widthAnchor(contentView.widthAnchor)
            .heightAnchor(contentView.heightAnchor)
        
        blackOpacityView
            .widthAnchor(contentView.widthAnchor)
            .heightAnchor(contentView.heightAnchor)
        
        durationLabel
            .centerXAnchor(contentView.centerXAnchor)
            .bottomAnchor(contentView.bottomAnchor, padding: -2)
    }
    
    func configureCell(thumbnails: [CGImage], duration: Double) {
        
        for thumbnail in thumbnails {
            let imageView = UIImageView(image: UIImage(cgImage: thumbnail))
            thumbnailStackView.addArrangedSubview(imageView)
        }
        
        durationLabel.text = "\(duration)s"
    }
    
}
