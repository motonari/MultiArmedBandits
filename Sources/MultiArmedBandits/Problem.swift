struct Problem {
    let values: [Double]

    var armCount: Int {
        values.count
    }

    init(armCount: Int) {
        values = (0..<armCount).map { _ in
            normallyDistributedRandom(mean: 0.0, standardDeviation: 1.0)
        }
    }

    func reward(action: Int) -> Double {
        guard 0 <= action && action < armCount else {
            fatalError("action must be 0..<\(armCount); \(action) was specified.")
        }

        return normallyDistributedRandom(mean: values[action], standardDeviation: 1.0)
    }

}
