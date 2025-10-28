struct Problem {
    let armCount: Int
    let unstationality: Double
    var values: [Double]

    /// - Parameters:
    ///  - armCount: The number of actions
    ///  - unstationality: Probability of change of value for each action.
    init(armCount: Int, unstationality: Double) {
        self.armCount = armCount
        self.unstationality = unstationality
        self.values = Self.newValues(armCount: armCount)
    }

    mutating func reward(action: Int) -> Double {
        guard 0 <= action && action < armCount else {
            fatalError("action must be 0..<\(armCount); \(action) was specified.")
        }

        if Double.random(in: 0.0..<1.0) < unstationality {
            values = Self.newValues(armCount: armCount)
        }

        return normallyDistributedRandom(mean: values[action], standardDeviation: 1.0)
    }

    private static func newValues(armCount: Int) -> [Double] {
        return (0..<armCount).map { _ in
            normallyDistributedRandom(mean: 0.0, standardDeviation: 1.0)
        }
    }

}
