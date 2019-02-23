import UIKit
import SpriteKit
var Score = 0 // public...
var HighScore = 0 //public...
class GameViewController: UIViewController {
    
    @IBOutlet var StartOverLbl: UIButton!
    
    @IBOutlet weak var ScoreLbl: UILabel!
    
    @IBOutlet weak var HighScoreLbl: UILabel!
    
    @IBOutlet weak var LivesLbl: UILabel!
    
    var scoreKeeper: ScoreKeeper!
    var scene: GameScene!
    var lifeCount: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        scene = GameScene(size: view.bounds.size)
        scene.viewController = self
        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        scoreKeeper = ScoreKeeper()
        skView.bringSubview(toFront: LivesLbl)
        LivesLbl.text = "Lives: "
        

        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func StartOverAction(_ sender: Any) {
        if scene.gameInProgress {
            endGame()
        }
        else{
            scoreKeeper.resetScore()
            lifeCount = 3
            LivesLbl.text = "Lives: 3"
            updateScoreLabels()
            scene.startGame()
        }
    }
    func endGame()
    {
        let endScore = scoreKeeper.getScore()
        scene.endGame()
        let alertController = UIAlertController(title: "Game Over! Final score: \(endScore) ", message: "1.3 billion tons of food is wasted every year! What can you do to decrease that amount? ", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title:"Dismiss",style:UIAlertActionStyle.default))
        self.present(alertController,animated:true,completion:nil)
        scoreKeeper.resetScore()
        lifeCount = 3
        updateScoreLabels()
    }
    func addScore(appleColor:Int)
    {
        //don't add points if out of lives
        if scene.gameInProgress {
            if lifeCount == 0 {
                //print("no points for apples after death") //DEBUG
                return
            }
            if (appleColor == 0) {
                scoreKeeper.increaseScore()
            }
            else if (appleColor == 1){
                scoreKeeper.addSilverFoodScore()
            }
            else if (appleColor == 2){
                scoreKeeper.addGoldFoodScore()
            }
            updateScoreLabels()
        }
    }

    func updateScoreLabels()
    {
        let score = scoreKeeper.getScore()
        let highscore = scoreKeeper.getHighScore()
        ScoreLbl.text = NSString(format: "Score: %i", score) as String
        if (score >= highscore){
            HighScoreLbl.text = NSString(format: "Highscore: %i", highscore) as String
        }
    }
    func loseALife(){
        if scene.gameInProgress {
            //then deduct a life
            lifeCount = lifeCount-1
            //and display number of lives left
            //print("life count: ", lifeCount) //DEBUG
            
            if lifeCount == 1{
                LivesLbl.text = "Lives: 1"
            }else if lifeCount == 2{
                LivesLbl.text = "Lives: 2"
            }
            else if lifeCount == 3{
                LivesLbl.text = "Lives: 3"
            }
            else if lifeCount == 0{
                LivesLbl.text = "Lives: 0"
                endGame()
            }
        }
    }
    
    // Screen width
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen width
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

}

