//
//  VideoTrackViewController.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/14/24.
//

import AVFoundation
import UIKit

final class VideoTrackViewController: UIViewController {
    
    private let imageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let playHeadView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        collectionView.register(MockCell.self, forCellWithReuseIdentifier: MockCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        addUserAction()
        Task { await makeVideoThumbnailImageView(time: 0, item: 0) }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 145, height: 145)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: view.frame.width / 2 + 2, bottom: 0, right: view.frame.width / 2 + 2)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func configureHierarchy() {
        self.view.addSubview(imageView)
        self.view.addSubview(collectionView)
        self.view.addSubview(playHeadView)
    }
    
    private func configureLayout() {
        imageView
            .topAnchor(view.safeAreaLayoutGuide.topAnchor, padding: 50)
            .centerXAnchor(view.centerXAnchor)
            .widthAnchor(view.widthAnchor)
            .heightAnchor(view.heightAnchor, multiplier: 0.35)
        
        collectionView
            .topAnchor(imageView.bottomAnchor, padding: 55)
            .centerXAnchor(view.centerXAnchor)
            .widthAnchor(view.widthAnchor)
            .heightAnchor(equalToConstant: 145)
        
        playHeadView
            .topAnchor(imageView.bottomAnchor, padding: 50)
            .centerXAnchor(view.centerXAnchor)
            .widthAnchor(equalToConstant: 3)
            .heightAnchor(equalToConstant: 155)
    }
    
    private func addUserAction() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        
        collectionView.addGestureRecognizer(longPressGR)
    }
    
    @objc
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func makeVideoThumbnailImageView(time: Double, item: Int) async {
        do {
            let time = CMTime(seconds: time, preferredTimescale: 600)
            let image = try await VideoAsset.thumbnailGeneratorList[item].image(at: time).image
    
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(cgImage: image)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension VideoTrackViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = findCellUnderPlayerHead() {
            Task {
                let videoTime = await calculateVideoTime(for: indexPath)
                await makeVideoThumbnailImageView(time: videoTime, item: indexPath.item)
            }
        }
    }
    
    func findCellUnderPlayerHead() -> IndexPath? {
        let visibleCells = collectionView.visibleCells
        
        for cell in visibleCells {
            let cellFrame = collectionView.convert(cell.frame, to: view)

            if playHeadView.frame.minX >= cellFrame.minX && playHeadView.frame.maxX <= cellFrame.maxX {
                if let indexPath = collectionView.indexPath(for: cell) {
                    return indexPath
                }
            }
        }
        
        return nil
    }
    
    func calculateVideoTime(for indexPath: IndexPath) async -> Double {
        let totalVideoDuration = await VideoAsset.loadDurationList()[indexPath.item]
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            let cellFrame = collectionView.convert(cell.frame, to: view)
            let playheadRelativePosition = (playHeadView.frame.minX - cellFrame.minX) / cellFrame.width
            let videoTime = playheadRelativePosition * totalVideoDuration
            return videoTime
        }
        
        return 0.0
    }
}

extension VideoTrackViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VideoAsset.thumbnailGeneratorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MockCell.id, for: indexPath) as? MockCell else { return UICollectionViewCell() }
        let imageGenerator = VideoAsset.thumbnailGeneratorList[indexPath.item]
        
        Task { await cell.configureCell(imageGenerator: imageGenerator) }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = VideoAsset.thumbnailGeneratorList.remove(at: sourceIndexPath.row)
        VideoAsset.thumbnailGeneratorList.insert(item, at: destinationIndexPath.row)
    }
}

final class MockCell: UICollectionViewCell {
    static let id = String(describing: MockCell.self)
    private let imageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(imageGenerator: AVAssetImageGenerator) async {
        do {
            let time = CMTime(seconds: 1, preferredTimescale: 600)
            let image = try await imageGenerator.image(at: time).image
    
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = UIImage(cgImage: image)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
