//
//  ImageExportService.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Photos
import SwiftUI
import UIKit

@MainActor
enum ImageExportService {
    static func renderImage<Content: View>(from view: Content, size: CGSize) -> UIImage {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }

    static func saveToPhotoLibrary(_ image: UIImage) async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        let authorized: Bool

        switch status {
        case .authorized, .limited:
            authorized = true
        case .notDetermined:
            let newStatus = await requestPhotoLibraryAuthorization()
            authorized = newStatus == .authorized || newStatus == .limited
        default:
            authorized = false
        }

        guard authorized else {
            throw ImageExportError.photoLibraryDenied
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: ImageExportError.photoLibraryDenied)
                }
            }
        }
    }

    private static func requestPhotoLibraryAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                continuation.resume(returning: status)
            }
        }
    }
}

enum ImageExportError: LocalizedError {
    case photoLibraryDenied

    var errorDescription: String? {
        switch self {
        case .photoLibraryDenied:
            return "没有相册写入权限，请在系统设置中允许初芽访问相册。"
        }
    }
}
