//
//  VideoTrackViewController.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/14/24.
//

import AVFoundation
import UIKit

final class VideoTrackViewController: UIViewController {
    
    private let rootView = VideoTrackView()
    private var videoTrackList: [VideoTrackModel]
    private var currentTask: Task<Void, Never>?
    
    init(videoTrackList: [VideoTrackModel]) {
        self.videoTrackList = videoTrackList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserAction()
        Task { await updateThumbnailImageView(time: 0, idx: 0) }
    }
    
    private func addUserAction() {
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.addGestureRecognizer(longPressGR)
    }
}

//MARK: - User Action Handling
extension VideoTrackViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentTask?.cancel()
        currentTask = Task { await trackCurrentThumbnail() }
    }
    
    @objc
    private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = rootView.collectionView.indexPathForItem(at: gesture.location(in: rootView.collectionView)) else { return }
            
            rootView.collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            rootView.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: rootView.collectionView))
        case .ended:
            rootView.collectionView.endInteractiveMovement()
        default:
            rootView.collectionView.cancelInteractiveMovement()
        }
    }
}

//MARK: - Presentation Logic
extension VideoTrackViewController {
    
    private func updateThumbnailImageView(time: Double, idx: Int) async {
        let time = CMTime(seconds: time, preferredTimescale: 600)

        if let image = try? await videoTrackList[idx].imageGenerator.image(at: time).image {
            rootView.updateImageView(image)
        }
    }
    
    private func trackCurrentThumbnail() async {
        let playHeadMidX = rootView.playHeadView.frame.midX
        let visibleCells = rootView.collectionView.visibleCells
        
        for cell in visibleCells {
            let cellFrame = rootView.collectionView.convert(cell.frame, to: view)

            if playHeadMidX >= cellFrame.minX && playHeadMidX <= cellFrame.maxX {
                if let indexPath = rootView.collectionView.indexPath(for: cell) {
                    let totalVideoDuration = videoTrackList[indexPath.item].duration
                    let playheadRelativePosition = (playHeadMidX - cellFrame.minX) / cellFrame.width
                    let videoTime = playheadRelativePosition * totalVideoDuration

                    await updateThumbnailImageView(time: videoTime, idx: indexPath.item)
                    break
                }
            }
        }
    }
}

//MARK: - Configure CollectionView
extension VideoTrackViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoTrackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as? VideoCell else { return UICollectionViewCell() }
        let thumbnails = videoTrackList[indexPath.item].thumbnails
        
        cell.configureCell(thumbnails: thumbnails)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = videoTrackList.remove(at: sourceIndexPath.row)
        
        videoTrackList.insert(item, at: destinationIndexPath.row)
        collectionView.collectionViewLayout.invalidateLayout()
        Task { await trackCurrentThumbnail() }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thumbnailCount = Float(videoTrackList[indexPath.item].thumbnails.count)
        let width: Float = 70
        let spacing: Float = 0.2
        let cellWidth = CGFloat(thumbnailCount * (width + spacing) - spacing)

        return CGSize(width: cellWidth, height: 75)
    }
}
