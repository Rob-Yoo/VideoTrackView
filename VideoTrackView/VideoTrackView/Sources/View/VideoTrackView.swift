//
//  VideoTrackView.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/20/24.
//

import UIKit

final class VideoTrackView: UIView {
    
    let imageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let playHeadView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure UI
extension VideoTrackView {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width / 2 + 2, bottom: 0, right: UIScreen.main.bounds.width / 2 + 2)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(collectionView)
        self.addSubview(playHeadView)
    }
    
    private func configureLayout() {
        imageView
            .topAnchor(self.safeAreaLayoutGuide.topAnchor, padding: 50)
            .centerXAnchor(self.centerXAnchor)
            .widthAnchor(self.widthAnchor)
            .heightAnchor(self.heightAnchor, multiplier: 0.35)
        
        collectionView
            .topAnchor(imageView.bottomAnchor, padding: 55)
            .centerXAnchor(self.centerXAnchor)
            .widthAnchor(self.widthAnchor)
            .heightAnchor(equalToConstant: 75)
        
        playHeadView
            .topAnchor(imageView.bottomAnchor, padding: 50)
            .centerXAnchor(self.centerXAnchor)
            .widthAnchor(equalToConstant: 3)
            .heightAnchor(equalToConstant: 85)
    }
}

//MARK: - Update UI
extension VideoTrackView {
    @MainActor
    func updateImageView(_ cgImage: CGImage) {
        imageView.image = UIImage(cgImage: cgImage)
    }
}
