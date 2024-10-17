//
//  VideoAsset.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/16/24.
//

import AVFoundation

enum VideoAsset {
    static private let videoBundleUrls = [
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
    
    static private let avAssetList = videoBundleUrls.map { AVAsset(url: $0) }
    
    static var thumbnailGeneratorList = avAssetList.map {
        let generator = AVAssetImageGenerator(asset: $0)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = CMTime(seconds: 3, preferredTimescale: 600)
        return generator
    }
    
    static func loadDurationList(assets: [AVAsset] = VideoAsset.avAssetList) async -> [Double] {
        var durationList = [Double]()
        
        for asset in assets {
            let duration = try? await asset.load(.duration)
            let seconds = duration?.seconds ?? 0.0
            durationList.append(seconds)
        }
        
        return durationList
    }
}
