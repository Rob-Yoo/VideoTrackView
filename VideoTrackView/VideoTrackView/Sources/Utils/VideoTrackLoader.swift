//
//  VideoTrackLoader.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/16/24.
//

import AVFoundation


final class VideoTrackLoader {
    
    private enum VideoAsset {
        static let fileNames = [
            "Sample1", "Sample2", "Sample3", "Sample4", "Sample5", "Sample6", "Sample7", "Sample8", "Sample9", "Sample10"
        ]
    }
    
    private let videoTracks: [String] = {
        return UserDefaultsStorage.videoTrackOrder ?? VideoAsset.fileNames
    }()
    
    func loadVideoTrackList() async -> [VideoTrackModel] {
        var videoTrackList = [VideoTrackModel]()
        
        for videoTrack in videoTracks {
    
            guard let url = Bundle.main.url(forResource: videoTrack, withExtension: "mp4") else { continue }

            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)

            imageGenerator.requestedTimeToleranceBefore = .zero
            imageGenerator.requestedTimeToleranceAfter = .zero
            let duration = (try? await asset.load(.duration).seconds) ?? 0.0
            var cmtimes = [CMTime]()
            var thumbnails = [CGImage]()
            
            for time in stride(from: 0, through: Int(duration), by: 5) {
                cmtimes.append(CMTime(seconds: Double(time), preferredTimescale: 600))
            }
            
            for await image in imageGenerator.images(for: cmtimes) {
                if let thumbnail = try? image.image {
                    thumbnails.append(thumbnail)
                } else {
                    print("실패")
                }
            }
            
            let videoTrackModel = VideoTrackModel(
                fileName: videoTrack,
                imageGenerator: imageGenerator,
                duration: duration,
                thumbnails: thumbnails
            )

            videoTrackList.append(videoTrackModel)
        }
        
        return videoTrackList
    }
}
