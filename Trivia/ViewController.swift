import UIKit

class ViewController: UIViewController {

    
    
    // MARK: - Outlets
    @IBOutlet weak var Question: UILabel!
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var ActualQuestion: UILabel!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!

    // MARK: - Question Model
    struct QuestionItem {
        let question: String
        let category: String
        let answers: [String]
        let correctAnswerIndex: Int
    }

    // MARK: - Data & State
    let questions: [QuestionItem] = [
        QuestionItem(
            question: "What is the main character of the anime 'Death Note'?",
            category: "Entertainment: Anime",
            answers: ["Light Yagami", "Naruto", "Goku", "Deku"],
            correctAnswerIndex: 0
        ),
        QuestionItem(
            question: "What fruit is yellow?",
            category: "Food: Fruit",
            answers: ["Apple", "Banana", "Strawberry", "Blueberry"],
            correctAnswerIndex: 1
        ),
        QuestionItem(
            question: "What does AOT stand for?",
            category: "Entertainment: Anime",
            answers: ["After Our Time", "Attack On Titan", "Alter Our Time", "Attack Of Titans"],
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

        Question.text = "Question: \(currentQuestionIndex + 1)/\(questions.count)"
        Category.text = current.category
        ActualQuestion.text = current.question

        Button1.setTitle(current.answers[0], for: .normal)
        Button2.setTitle(current.answers[1], for: .normal)
        Button3.setTitle(current.answers[2], for: .normal)
        Button4.setTitle(current.answers[3], for: .normal)

        [Button1, Button2, Button3, Button4].forEach {
            $0?.isEnabled = true
            $0?.backgroundColor = UIColor.systemBlue
        }
    }

    // MARK: - Handle Answer Selection
    @IBAction func answerSelected(_ sender: UIButton) {
        let current = questions[currentQuestionIndex]
        let selectedIndex: Int

        switch sender {
        case Button1: selectedIndex = 0
        case Button2: selectedIndex = 1
        case Button3: selectedIndex = 2
        case Button4: selectedIndex = 3
        default: return
        }

        if selectedIndex == current.correctAnswerIndex {
            score += 1
        }

        [Button1, Button2, Button3, Button4].forEach { $0?.isEnabled = false }

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
        [Button1, Button2, Button3, Button4].forEach {
            $0?.isHidden = false
        }
        loadQuestion()
    }
}
