import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let apple    : UInt32 = 0b1       // 1
    static let mouth    : UInt32 = 0b10      // 2
    static let trash    : UInt32 = 0b11      // 3
//    static let pineapple : UInt32 = 0b101
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var viewController: GameViewController!
    var gameInProgress: Bool = false
    
    var background = SKSpriteNode(imageNamed: "background")

    // Mouth
    let mouth = SKSpriteNode(imageNamed: "basket")
    let trash = SKSpriteNode(imageNamed: "background")
    
    override func didMove(to view: SKView) {
        background.zPosition = 0
        background.position = CGPoint(x:frame.size.width / 2, y:frame.size.height / 2)
        addChild(background)
        
        mouth.zPosition = 1
        mouth.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6)
        addChild(mouth)
        
        trash.zPosition = 1
        trash.size = CGSize(width:viewController.screenWidth, height: viewController.screenHeight * 0.75)
        trash.position = CGPoint(x: size.width * 0.5, y: size.height * 0.6 - 500)
        trash.alpha = 0.0
        addChild(trash)
        
       
        //Physics world has no gravity and can now detect collision
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        trash.physicsBody = SKPhysicsBody(rectangleOf: trash.size )
        trash.physicsBody?.isDynamic = true
        trash.physicsBody?.categoryBitMask = PhysicsCategory.trash
        trash.physicsBody?.contactTestBitMask = PhysicsCategory.apple
//        trash.physicsBody?.contactTestBitMask = PhysicsCategory.pineapple
        trash.physicsBody?.collisionBitMask = PhysicsCategory.None
        trash.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func startGame(){
        
        if !gameInProgress{
//            run(SKAction.repeatForever(
//
//                SKAction.sequence([
//                    SKAction.run(addPineapple, addapple),
//                    SKAction.wait(forDuration: 3.0)
//                    ])
//
//            ), withKey:"runGame")
            
            run(SKAction.repeatForever(
                
                SKAction.sequence([
                    SKAction.run(addapple),
                    SKAction.wait(forDuration: 1.0)
                ])
                
            ), withKey:"runGame")
            
           
            
            gameInProgress = true
            
            // print("game started")//DEBUG
            
        }
    }
    
    func endGame(){
        removeAction(forKey: "runGame")
        gameInProgress = false
    }
    
    //set physics bodies
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mouth.physicsBody = SKPhysicsBody(circleOfRadius: mouth.size.width/2)
        mouth.physicsBody?.isDynamic = true
        mouth.physicsBody?.categoryBitMask = PhysicsCategory.mouth
        mouth.physicsBody?.contactTestBitMask = PhysicsCategory.apple
//        mouth.physicsBody?.contactTestBitMask = PhysicsCategory.pineapple
        mouth.physicsBody?.collisionBitMask = PhysicsCategory.None
        mouth.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    //move mouth left and right
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            mouth.position.x = location.x
        }
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addapple() {
        
        // Create sprite
        let apple = SKSpriteNode(imageNamed: "apple")
        
        // Set Physics Body
        apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size) // 1
        apple.physicsBody?.isDynamic = true // 2
        apple.physicsBody?.categoryBitMask = PhysicsCategory.apple // 3
        apple.physicsBody?.contactTestBitMask = PhysicsCategory.mouth // 4
        apple.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine where to spawn the apple along the X axis
        let actualX = random(min: apple.size.width/2, max: size.width - apple.size.width/2)
        
        // Position the apple slightly off-screen along the top, and along a random position along the X axis as calculated above
        apple.position = CGPoint(x: actualX, y: size.height + apple.size.height/2)
        
        //layer
        apple.zPosition = 1
        
        // Add the apple to the scene
        addChild(apple)
        
        // Determine speed of the apple
        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -apple.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        apple.run(SKAction.sequence([actionMove, actionMoveDone]))
  
    }
    
//    func addPineapple() {
//
//        // Create sprite
//        let pineapple = SKSpriteNode(imageNamed: "pineapple")
//
//        // Set Physics Body
//        pineapple.physicsBody = SKPhysicsBody(rectangleOf: pineapple.size) // 1
//        pineapple.physicsBody?.isDynamic = true // 2
//        pineapple.physicsBody?.categoryBitMask = PhysicsCategory.pineapple // 3
//        pineapple.physicsBody?.contactTestBitMask = PhysicsCategory.mouth // 4
//        pineapple.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
//
//        // Determine where to spawn the pineapple along the X axis
//        let actualX = random(min: pineapple.size.width/2, max: size.width - pineapple.size.width/2)
//
//        // Position the pineapple slightly off-screen along the top, and along a random position along the X axis as calculated above
//        pineapple.position = CGPoint(x: actualX, y: size.height + pineapple.size.height/2)
//
//        //layer
//        pineapple.zPosition = 1
//
//        // Add the apple to the scene
//        addChild(pineapple)
//
//        // Determine speed of the apple
//        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.0))
//
//        // Create the actions
//        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -pineapple.size.height/2), duration: TimeInterval(actualDuration))
//        let actionMoveDone = SKAction.removeFromParent()
//        pineapple.run(SKAction.sequence([actionMove, actionMoveDone]))
//
//    }
    
    // Detect Mouth eating the apple and then delete the apple
    func mouthDidCollideWithApple(mouth: SKSpriteNode, apple: SKSpriteNode){
        apple.removeFromParent()
        viewController.addScore(appleColor: 0)
    }
    
    // Detect Trash eating the apple and then delete the apple
    func trashDidCollideWithApple(trash: SKSpriteNode, apple: SKSpriteNode){
        apple.removeFromParent()
        viewController.loseALife()
    }

//    // Detect Mouth eating the apple and then delete the apple
//    func mouthDidCollideWithPineapple(mouth: SKSpriteNode, pineapple: SKSpriteNode){
//        pineapple.removeFromParent()
//        viewController.addScore(appleColor: 1)
//    }
    
    // Detect Trash eating the apple and then delete the apple
//    func trashDidCollideWithPineapple(trash: SKSpriteNode, pineapple: SKSpriteNode){
//        pineapple.removeFromParent()
//        viewController.loseALife()
//    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var otherBody: SKPhysicsBody
        var appleBody: SKPhysicsBody
//        var pineappleBody: SKPhysicsBody
        
        otherBody = contact.bodyB //delete later
        appleBody = contact.bodyA// delete later
//        pineappleBody = contact.bodyA
        
        
        // Determine what type of object bodyA is and assign it as needed
        if contact.bodyA.categoryBitMask == PhysicsCategory.apple {
            appleBody = contact.bodyA
            //print("BodyA ", contact.bodyA.categoryBitMask, " is apple ", PhysicsCategory.apple) //DEBUG
        }
//        else if contact.bodyA.categoryBitMask == PhysicsCategory.pineapple {
//            pineappleBody = contact.bodyA
//            //print("BodyA ", contact.bodyA.categoryBitMask, " is pineapple ", PhysicsCategory.pineapple) //DEBUG
//        }
        else if contact.bodyA.categoryBitMask == PhysicsCategory.mouth{
            otherBody = contact.bodyA
            // print("BodyA ", contact.bodyA.categoryBitMask, " is mouth ", PhysicsCategory.mouth) //DEBUG
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.trash{
            otherBody = contact.bodyA
            // print("BodyA ", contact.bodyA.categoryBitMask, " is trash ", PhysicsCategory.trash) //DEBUG
        }else{
            // print("error -- BodyA is unknown phsyics category") //DEBUG
        }
        
        
        // Determine what type of object bodyB is and assign it as needed
        if contact.bodyB.categoryBitMask == PhysicsCategory.apple {
            appleBody = contact.bodyB
            print("BodyB ", contact.bodyB.categoryBitMask, " is apple ", PhysicsCategory.apple)
        }
//        else if contact.bodyB.categoryBitMask == PhysicsCategory.pineapple {
//            pineappleBody = contact.bodyB
//            print("BodyB ", contact.bodyB.categoryBitMask, " is pineapple ", PhysicsCategory.pineapple)
//        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.mouth{
            otherBody = contact.bodyB
            print("BodyB ", contact.bodyB.categoryBitMask, " is mouth ", PhysicsCategory.mouth)
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.trash{
            otherBody = contact.bodyB
            print("BodyB ", contact.bodyB.categoryBitMask, " is trash ", PhysicsCategory.trash)
        }else{
            print("ERROR -- BodyB is unknown phsyics category")
        }
        
        
        
        // If other object is apple, add point
        if otherBody.categoryBitMask == PhysicsCategory.mouth {
            //print("Other body is mouth") //DEBUG
            if let apple = appleBody.node as? SKSpriteNode, let
                mouth = otherBody.node as? SKSpriteNode {
                mouthDidCollideWithApple(mouth: mouth, apple: apple)
            }
            
//            if let pineapple = pineappleBody.node as? SKSpriteNode, let
//                mouth = otherBody.node as? SKSpriteNode {
//                mouthDidCollideWithPineapple(mouth: mouth, pineapple: pineapple)
//            }
        }
            
        // Else if other object is trash, lose life
            
        else if otherBody.categoryBitMask == PhysicsCategory.trash {
            
            //print("Other body is trash") //DEBUG
            
            if let apple = appleBody.node as? SKSpriteNode, let
                
                trash = otherBody.node as? SKSpriteNode {
                
                trashDidCollideWithApple(trash: trash, apple: apple)
                
            }
            
//            if let pineapple = pineappleBody.node as? SKSpriteNode, let trash = otherBody.node as? SKSpriteNode {
//
//                trashDidCollideWithPineapple(trash: trash, pineapple: pineapple)
//
//            }
        }
    }
}
