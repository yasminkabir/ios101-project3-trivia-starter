import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!

    // MARK: - Question Model
    struct Question {
        let question: String
        let category: String
        let answers: [String]
        let correctAnswerIndex: Int
    }

    // MARK: - Data & State
    let questions: [Question] = [
        Question(
            question: "What was the first weapon pack for 'PAYDAY'?",
            category: "Entertainment: Video Games",
            answers: ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"],
            correctAnswerIndex: 0
        ),
        Question(
            question: "Who developed Sonic the Hedgehog?",
            category: "Entertainment: Video Games",
            answers: ["Nintendo", "SEGA", "Capcom", "Bandai Namco"],
            correctAnswerIndex: 1
        ),
        Question(
            question: "What year was the PlayStation 5 released?",
            category: "Entertainment: Video Games",
            answers: ["2019", "2020", "2021", "2018"],
            correctAnswerIndex: 1
        )
    ]

    var currentQuestionIndex = 0
    var score = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestion()
    }

    // MARK: - Load Question
    func loadQuestion() {
        let current = questions[currentQuestionIndex]

        questionNumberLabel.text = "Question: \(currentQuestionIndex + 1)/\(questions.count)"
        categoryLabel.text = current.category
        questionLabel.text = current.question

        answerButton1.setTitle(current.answers[0], for: .normal)
        answerButton2.setTitle(current.answers[1], for: .normal)
        answerButton3.setTitle(current.answers[2], for: .normal)
        answerButton4.setTitle(current.answers[3], for: .normal)

        [answerButton1, answerButton2, answerButton3, answerButton4].forEach {
            $0?.isEnabled = true
            $0?.backgroundColor = UIColor.systemBlue
        }
    }

    // MARK: - Handle Answer Selection
    @IBAction func answerSelected(_ sender: UIButton) {
        let current = questions[currentQuestionIndex]
        let selectedIndex: Int

        switch sender {
        case answerButton1: selectedIndex = 0
        case answerButton2: selectedIndex = 1
        case answerButton3: selectedIndex = 2
        case answerButton4: selectedIndex = 3
        default: return
        }

        if selectedIndex == current.correctAnswerIndex {
            score += 1
        }

        [answerButton1, answerButton2, answerButton3, answerButton4].forEach { $0?.isEnabled = false }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentQuestionIndex += 1

            if self.currentQuestionIndex < self.questions.count {
                self.loadQuestion()
            } else {
                self.showFinalScore()
            }
        }
    }

    // MARK: - Show Final Score
    func showFinalScore() {
        let alert = UIAlertController(
            title: "Quiz Complete!",
            message: "You got \(score) out of \(questions.count) correct!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true)
    }

    // MARK: - Restart Game
    func restartGame() {
        currentQuestionIndex = 0
        score = 0
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach {
            $0?.isHidden = false
        }
        loadQuestion()
    }
}
