//
//  VideoTrackLoader.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/16/24.
//

import AVFoundation

final class VideoTrackLoader {
    
    private let videoBundleUrls = [
        Bundle.main.url(forResource: "Sample1", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample2", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample3", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample4", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample5", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample6", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample7", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample8", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample9", withExtension: "mp4"),
        Bundle.main.url(forResource: "Sample10", withExtension: "mp4")
    ].compactMap { $0 }
    
    func loadVideoTrackList() async -> [VideoTrackModel] {
        var videoTrackList = [VideoTrackModel]()

        for url in videoBundleUrls {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.requestedTimeToleranceBefore = CMTime(seconds: 0.5, preferredTimescale: 600)
            imageGenerator.requestedTimeToleranceAfter = CMTime(seconds: 0.5, preferredTimescale: 600)
            
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
                imageGenerator: imageGenerator,
                duration: duration,
                thumbnails: thumbnails
            )

            videoTrackList.append(videoTrackModel)
        }
        
        return videoTrackList
    }
}
