// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct MultiArmedBandits {
    static let armCount = 10

    static func run(
        scorecard: Scorecard,
        columnIndex: Int,
        testCase: TestCase,
        stepCount: Int,
        runCount: Int
    ) async {
        for _ in 0..<runCount {
            var problem = Problem(armCount: armCount, unstationality: testCase.unstationality)
            var agent = Agent(armCount: armCount, epsilon: testCase.exploration, stepSize: testCase.stepSize)
            for step in 0..<stepCount {
                let action = agent.nextAction()
                let reward = problem.reward(action: action)
                agent.update(action: action, reward: reward)

                let averageReward = step == 0 ? 0 : agent.totalReward / Double(step)
                await scorecard.add(
                    score: averageReward,
                    row: step,
                    column: columnIndex)
            }
        }
    }
    
    static func epsilonGreedyTest(
      baseName: String,
      title: String,
      testCases: [TestCase],
      stepCount: Int,
      runCount: Int
    ) async {
        let scorecard = Scorecard(
          baseName: baseName,
          title: title,
          rowCount: stepCount,
          columns: testCases.map(\.title))

        await withTaskGroup(
          of: Void.self,
          returning: Void.self
        ){ group in 
            for (testCaseIndex, testCase) in testCases.enumerated() {
                group.addTask {
                    await run(
                      scorecard: scorecard,
                      columnIndex: testCaseIndex,
                      testCase: testCase,
                      stepCount: stepCount,
                      runCount: runCount)
                }
            }
            for await _ in group {}
        }
        
        await scorecard.write()
    }
    
    static func main() async {
        await epsilonGreedyTest(
          baseName: "stationaly",
          title: "Average Performance of ε-greedy action-value method with stationaly problem",
          testCases: [
            TestCase(title: "ε=0.10", exploration: 0.10, stepSize: .average, unstationality: false),
            TestCase(title: "ε=0.01", exploration: 0.01, stepSize: .average, unstationality: false),
            TestCase(title: "ε=0.00", exploration: 0.00, stepSize: .average, unstationality: false),
          ],
          stepCount: 1000,
          runCount: 2000
        )

        await epsilonGreedyTest(
          baseName: "stepSize",
          title: "Average Performance of different step sizes with unstationaly problem",
          testCases: [
            TestCase(title: "average",
                     exploration: 0.1,
                     stepSize: .average,
                     unstationality: true
            ),
            
            TestCase(title: "step size 0.1",
                     exploration: 0.1,
                     stepSize: .fixed(alpha: 0.1),
                     unstationality: true
            ),
            
            TestCase(title: "step size 0.5",
                     exploration: 0.1,
                     stepSize: .fixed(alpha: 0.5),
                     unstationality: true
            ),
          ],
          stepCount: 10000,
          runCount: 200
        )
    }
}
