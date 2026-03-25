//
//  AppearanceFrequency.swift
//  RickyBuggyBright
//

import Foundation


/// Level selected based on number of appearances in the show, if character appeared 10 times or more - it's high, if 3 times or more - its medium, if 1 or lower - it's low
enum AppearanceFrequency: String, CaseIterable {
    case high = "So popular!"
    case medium = "Kind of popular"
    case low = "Meh"
    
    private var frequencyRange: Range<Int> {
        switch self {
        case .high: 10..<Int.max
        case .medium: 3..<10
        case .low: 0..<3 //For appearances = 2 -> it's not defined for now, i will assign it to .low
        }
    }
}

extension AppearanceFrequency {
    static func getBy(appearances: Int) -> AppearanceFrequency {
        allCases.first { $0.frequencyRange.contains(appearances) } ?? .low
    }
}
