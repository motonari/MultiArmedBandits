import Foundation

struct Scorecard {
    var data: [[Double]]
    var count: [[Int]]

    init(rowCount: Int, columnCount: Int) {
        let defaultDataRow = Array(repeating: 0.0, count: columnCount)
        self.data = Array(repeating: defaultDataRow, count: rowCount)

        let defaultCountRow = Array(repeating: 0, count: columnCount)
        self.count = Array(repeating: defaultCountRow, count: rowCount)
    }

    mutating func add(score: Double, row: Int, column: Int) {
        count[row][column] += 1
        data[row][column] =
            data[row][column] + (score - data[row][column]) / Double(count[row][column])
    }

    func write(to fileURL: URL) {
        try! "".write(to: fileURL, atomically: true, encoding: .utf8)  // Create an empty file

        let file = try! FileHandle(forWritingTo: fileURL)
        for row in data {
            let rowString = row.map { String($0) }.joined(separator: " ") + "\n"
            file.write(rowString.data(using: .utf8)!)
        }
    }

}
