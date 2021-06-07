import Foundation

private struct Pair<T : Hashable, U : Hashable> : Hashable {
    let first: T
    let second: U
}

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        var vImage = image
        var pixelCandidates: Set = [Pair(first: row, second: column)]
        while !pixelCandidates.isEmpty {
            let toFillPixel = pixelCandidates.popFirst()
            let newCandidates = self.getFourConnectedSameColorPixels(vImage, toFillPixel!.first, toFillPixel!.second)
            vImage[toFillPixel!.first][toFillPixel!.second] = newColor
            pixelCandidates = pixelCandidates.union(newCandidates)
        }
        return vImage
    }
    
    private func getFourConnectedSameColorPixels(_ image: [[Int]], _ row: Int, _ column: Int) -> Set<Pair<Int, Int>> {
        var pixelCandidates: Set<Pair<Int, Int>> = []
        if image.count == 0 {
            return pixelCandidates
        }
        for i in -1...1 {
            if column + i == column {
                continue
            }
            if let element = image[safe: row]?[safe: column + i] {
                if element == image[row][column] {
                    pixelCandidates.insert(Pair(first: row, second: column + i))
                }
            }
        }
        for j in -1...1 {
            if row + j == row {
                continue
            }
            if let element = image[safe: row + j]?[safe: column] {
                if element == image[row][column] {
                    pixelCandidates.insert(Pair(first: row + j, second: column))
                }
            }
        }
        return pixelCandidates
    }
}



