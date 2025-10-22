import Foundation

struct Scorecard {
    let baseName: String
    let title: String
    let columns: [String]
    var data: [[Double]]
    var count: [[Int]]

    init(
        baseName: String,
        title: String,
        rowCount: Int,
        columns: [String]
    ) {
        self.baseName = baseName
        self.title = title
        self.columns = columns

        let defaultDataRow = Array(repeating: 0.0, count: columns.count)
        self.data = Array(repeating: defaultDataRow, count: rowCount)

        let defaultCountRow = Array(repeating: 0, count: columns.count)
        self.count = Array(repeating: defaultCountRow, count: rowCount)
    }

    mutating func add(score: Double, row: Int, column: Int) {
        count[row][column] += 1
        data[row][column] =
            data[row][column] + (score - data[row][column]) / Double(count[row][column])
    }

    func write() {
        let fileURL = URL(fileURLWithPath: "\(baseName).gp")
        try! "$data <<EOD\n".write(to: fileURL, atomically: true, encoding: .utf8)

        let file = try! FileHandle(forWritingTo: fileURL)
        try! file.seekToEnd()
        for row in data {
            let rowString = row.map { String($0) }.joined(separator: " ") + "\n"
            file.write(rowString.data(using: .utf8)!)
        }

        file.write("EOD\n".data(using: .utf8)!)

        var command = """
            set title "\(title)
            set xlabel "Steps"
            set ylabel "Average Reward"
            plot
          """

        let colors = ["blue", "red", "green"]
        for (index, columnTitle) in columns.enumerated() {
            command += "$data using 0:\(index+1) with line lc '\(colors[index])' title '\(columnTitle)',"
        }

        command += "\n"
        file.write(command.data(using: .utf8)!)
    }
}
