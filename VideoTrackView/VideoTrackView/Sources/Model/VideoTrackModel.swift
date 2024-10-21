//
//  VideoTrackModel.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/20/24.
//

import AVFoundation

struct VideoTrackModel {
    let fileName: String
    let imageGenerator: AVAssetImageGenerator
    let duration: Double
    let thumbnails: [CGImage]
}
