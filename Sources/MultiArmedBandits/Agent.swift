struct Agent {
    let epsilon: Double
    var sumOfRewardsForAction: [Double]
    var actionCounts: [Int]

    init(armCount: Int, epsilon: Double) {
        self.epsilon = epsilon
        self.sumOfRewardsForAction = [Double](repeating: 0.0, count: armCount)
        self.actionCounts = [Int](repeating: 0, count: armCount)
    }

    var estimatedValues: [Double] {
        return zip(sumOfRewardsForAction, actionCounts)
            .map { sumOfRewards, actionCount in
                if actionCount == 0 {
                    return 0.0
                } else {
                    return sumOfRewards / Double(actionCount)
                }
            }
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
        self.sumOfRewardsForAction.reduce(0, +)
    }

    mutating func update(action: Int, reward: Double) {
        sumOfRewardsForAction[action] += reward
        actionCounts[action] += 1
    }
}
