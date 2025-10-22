// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct MultiArmedBandits {
    static let stepCount = 1000
    static let runCount = 2000
    static let armCount = 10

    static func run(
        scorecard: inout Scorecard,
        columnIndex: Int,
        exploration: Double,
        unstationality: Double
    ) {
        for _ in 0..<runCount {
            var problem = Problem(armCount: armCount, unstationality: unstationality)
            var agent = Agent(armCount: armCount, epsilon: exploration)
            for step in 0..<stepCount {
                let action = agent.nextAction()
                let reward = problem.reward(action: action)
                agent.update(action: action, reward: reward)

                let averageReward = step == 0 ? 0 : agent.totalReward / Double(step)
                scorecard.add(
                    score: averageReward,
                    row: step,
                    column: columnIndex)
            }
        }
    }

    static func epsilonGreedyTest(unstationality: Double) {
        let explorations = [0.3, 0.1, 0.01, 0]
        let stationalityString = unstationality > 0 ? "unstationaly" : "stationaly"
        var scorecardByExploration = Scorecard(
          baseName: stationalityString,
          title: "Average Performance of ε-greedy action-value method with \(stationalityString) problem",
          rowCount: stepCount,
          columns: ["ε = 0.3", "ε = 0.1", "ε = 0.01", "ε = 0.0"])
        
        for (testCaseIndex, exploration) in explorations.enumerated() {
            run(
                scorecard: &scorecardByExploration,
                columnIndex: testCaseIndex,
                exploration: exploration,
                unstationality: unstationality)
        }

        scorecardByExploration.write()
    }

    
    static func main() {
        epsilonGreedyTest(unstationality: 0.0)
        epsilonGreedyTest(unstationality: 0.01)
    }
}
