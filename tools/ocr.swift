// Apple Vision OCR cross-check for transcription review.
//
// Usage (from the repo root, on macOS with Xcode command line tools):
//     swift tools/ocr.swift
//
// Reads  images/originals/page-NNN.jpg
// Writes ocr-text/page-NNN.txt (one file per page, recognized text lines
// in top-to-bottom order). ocr-text/ is gitignored; it exists only to be
// diffed against the transcriptions in _recipes/.

import Foundation
import Vision
import AppKit

let fm = FileManager.default
let inputDir = "images/originals"
let outputDir = "ocr-text"

func recognizeText(in imagePath: String) throws -> String {
    guard let image = NSImage(contentsOfFile: imagePath),
          let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    else {
        throw NSError(domain: "ocr", code: 1,
                      userInfo: [NSLocalizedDescriptionKey: "Cannot load \(imagePath)"])
    }

    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    request.recognitionLanguages = ["en-US"]

    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    try handler.perform([request])

    let observations = request.results ?? []
    // Sort top-to-bottom (Vision Y axis is bottom-up), then left-to-right.
    let sorted = observations.sorted {
        let a = $0.boundingBox, b = $1.boundingBox
        return abs(a.midY - b.midY) > 0.01 ? a.midY > b.midY : a.minX < b.minX
    }
    return sorted
        .compactMap { $0.topCandidates(1).first?.string }
        .joined(separator: "\n")
}

try? fm.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

let pages = try fm.contentsOfDirectory(atPath: inputDir)
    .filter { $0.hasSuffix(".jpg") }
    .sorted()

var failures = 0
for (i, page) in pages.enumerated() {
    let outName = (page as NSString).deletingPathExtension + ".txt"
    let outPath = "\(outputDir)/\(outName)"
    if fm.fileExists(atPath: outPath) {
        print("[\(i + 1)/\(pages.count)] \(page) — exists, skipping")
        continue
    }
    do {
        let text = try recognizeText(in: "\(inputDir)/\(page)")
        try text.write(toFile: outPath, atomically: true, encoding: .utf8)
        print("[\(i + 1)/\(pages.count)] \(page) — \(text.count) chars")
    } catch {
        failures += 1
        print("[\(i + 1)/\(pages.count)] \(page) — FAILED: \(error.localizedDescription)")
    }
}
print("Done. \(pages.count - failures)/\(pages.count) pages OCRed.")
