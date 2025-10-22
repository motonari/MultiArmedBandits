// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@main
struct multi_armed_bandits {
    static func main() {
        let stepCount = 1000
        let runCount = 2000
        let armCount = 10
        let epsilons = [0.1, 0.01, 0]

        var averageRewards = Scorecard(rowCount: stepCount, columnCount: epsilons.count)

        for (testCaseIndex, epsilon) in epsilons.enumerated() {
            for _ in 0..<runCount {
                let problem = Problem(armCount: armCount)
                var agent = Agent(armCount: armCount, epsilon: epsilon)
                for step in 0..<stepCount {
                    let action = agent.nextAction()
                    let reward = problem.reward(action: action)
                    agent.update(action: action, reward: reward)

                    let averageReward = step == 0 ? 0 : agent.totalReward / Double(step)
                    averageRewards.add(
                        score: averageReward,
                        row: step,
                        column: testCaseIndex)
                }
            }
        }

        let fileURL = URL(fileURLWithPath: "averageRewards.txt")
        averageRewards.write(to: fileURL)

        let gnuplot = """
            set title 'Average Performance of ε-greedy action-value method'
            set xlabel "Steps"
            set ylabel "Average Reward"
            plot 'averageRewards.txt' \
            using 0:1 with line lc 'blue' title 'epsilon=0.1', \
            '' using 0:2 with line lc 'red' title 'epsilon=0.01', \
            '' using 0:3 with line lc 'green' title 'epsilon=0.0'
            """
        print(gnuplot)
    }
}
