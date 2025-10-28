enum StepSize {
    case average
    case fixed(alpha: Double)
}

struct Agent {
    let epsilon: Double
    let stepSize: StepSize
    var estimatedValues: [Double]
    var actionCounts: [Int]

    init(armCount: Int, epsilon: Double, stepSize: StepSize) {
        self.epsilon = epsilon
        self.estimatedValues = [Double](repeating: 0.0, count: armCount)
        self.actionCounts = [Int](repeating: 0, count: armCount)
        self.stepSize = stepSize
    }

    func nextAction() -> Int {
        let takeGreedyAction = Double.random(in: 0.0..<1.0) > epsilon

        if takeGreedyAction {
            guard let index = maxElementIndex(of: estimatedValues) else {
                fatalError("No action is available.")
            }
            return index
        } else {
            return Int.random(in: 0..<self.actionCounts.count)
        }
    }

    var totalReward: Double {
        zip(estimatedValues, actionCounts)
          .map { estimatedValue, actionCount in
              estimatedValue * Double(actionCount)
          }
          .reduce(0, +)
    }

    mutating func update(action: Int, reward: Double) {
        actionCounts[action] += 1

        var alpha = 0.0
        switch stepSize {
        case .average:
            alpha = 1.0 / Double(actionCounts[action])
        case .fixed(let stepSizeAlpha):
            alpha = stepSizeAlpha
        }
        
        estimatedValues[action] += (reward - estimatedValues[action]) * alpha
    }
}
