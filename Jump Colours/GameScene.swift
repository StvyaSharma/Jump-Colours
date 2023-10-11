//
//  GameScene.swift
//  Jump Colours
//
//  Created by Stvya Sharma on 22/05/21.
//

import SpriteKit
import GameplayKit
import AVFoundation
import CoreData



public class GameScene: SKScene, SKPhysicsContactDelegate {
//: ### Physics
    struct PhysicsCategory{
        static let Player: UInt32 = 1
        static let Obstacles: UInt32 = 2
    }
    let player = SKShapeNode(circleOfRadius: 20)
    let obstacleSpacing: CGFloat = 800
    let cameraNode = SKCameraNode()
    let HighScoreLabel = SKLabelNode()
    let backButtonLabel = SKLabelNode()
    var backbuttonlogo:SKSpriteNode!
     var highscore = 0
    var pauseButton:SKSpriteNode!
//: ### Starting Function
    public func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode{
            if nodeA.fillColor != nodeB.fillColor{
                player.physicsBody?.velocity.dy = 0
                player.removeFromParent()
                score = 0
                HighScoreLabel.text = String("High Score : \(highscore)")
                backButtonLabel.text = "Back"
                scoreLabel.text = String(score)
                let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
                addPlayer(colour: colours.randomElement()!)
            }
            if nodeA.fillColor == nodeB.fillColor{
                score += 1
                self.sound(sound: "Color Switch Bounce", type: "mp3", loops: 0)
                
                if highscore < score {
                    highscore = score
                }
                
                HighScoreLabel.text = String("High Score : \(highscore)")
                scoreLabel.text = String(score)
                
            }
        }
    }
    func nodeInit() {
        pauseButton = self.childNode(withName: "pauseButton") as? SKSpriteNode
        pauseButton.position.y = cameraNode.position.y + 525
        backbuttonlogo = self.childNode(withName: "backbuttonlogo") as? SKSpriteNode
        backbuttonlogo.position.y = cameraNode.position.y + 525
        
        
    }
    
//: ### Adding Player
    func addPlayer(colour: UIColor){
        player.fillColor = colour
        player.strokeColor = player.fillColor
        player.position = CGPoint(x: 0, y: -200)
        //Physics Properties
        let playerBody = SKPhysicsBody(circleOfRadius: 15)
        playerBody.mass = 1.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        player.physicsBody = playerBody
        //Add to scene
        addChild(player)
    }
    func addCircle(yHeight : Int, radius : CGFloat , rotation : CGFloat){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x:0, y: -160))
        path.addArc(withCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(3.0 * (Double.pi / 2)), endAngle: CGFloat(0), clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero, radius: radius + 40, startAngle: CGFloat(0.0), endAngle: CGFloat(3.0 * (Double.pi / 2)), clockwise: false)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: 0, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: rotation * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    func addInvertedCircle(yHeight : Int, radius : CGFloat , rotation : CGFloat){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x:0, y: -160))
        path.addArc(withCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(3.0 * (Double.pi / 2)), endAngle: CGFloat(0), clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero, radius: radius + 40, startAngle: CGFloat(0.0), endAngle: CGFloat(3.0 * (Double.pi / 2)), clockwise: false)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.purple, UIColor.blue, UIColor.red, UIColor.yellow]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: 0, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: rotation * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
//: ### Square Obstacle
    func addSquare(yHeight : Int, width : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: -width/2, y: -width/2, width: width, height: 40), cornerRadius: 20)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: 0, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    func addInvertedSquare(yHeight : Int , width : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: -width/2, y: -width/2, width: width, height: 40), cornerRadius: 20)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: 0, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    
    func addCross(yHeight : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: 350, height: 40), cornerRadius: 20)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: 200, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    func addInvertedCross(yHeight : Int){
        let path = UIBezierPath(roundedRect: CGRect(x: -20, y: -20, width: 350, height: 40), cornerRadius: 20)
        let obstacle = SKNode()
        for i in 0...3{
            let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
            let section = SKShapeNode(path: path.cgPath)
            section.position = CGPoint(x: 0, y: 0)
            section.fillColor = colours[i]
            section.strokeColor = colours[i]
            section.zRotation = CGFloat(Double.pi / 2) * CGFloat(i);
            //Physics Properties
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacles
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            //Add to Obstacle
            obstacle.addChild(section)
        }
        obstacle.position = CGPoint(x: -200, y: yHeight)
        addChild(obstacle)
        let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 8.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    func addDoubleCross(yHeight: Int){
        addCross(yHeight: yHeight)
        addInvertedCross(yHeight: yHeight)
    }
    func addTripleCircles(yHeight: Int ,variableradius : CGFloat){
        addCircle(yHeight: yHeight, radius: variableradius, rotation: +2.0)
        addInvertedCircle(yHeight: yHeight, radius: variableradius-50, rotation: -2.0)
        addCircle(yHeight: yHeight, radius: variableradius-100, rotation: +2.0)
        
    }
    func addDoubleSquare(yHeight: Int , variableradius : Int){
        addSquare(yHeight: yHeight, width: variableradius )
        addInvertedSquare(yHeight: yHeight, width: variableradius - 100)
    }
    func addSquareCircle(yHeight: Int , circleRadius: CGFloat , rectangleSize : Int){
        addInvertedCircle(yHeight: yHeight, radius: circleRadius, rotation: 2.0)
        addSquare(yHeight: yHeight, width: rectangleSize)
    }
    func addCrossCircle(yHeight : Int){
        addDoubleCross(yHeight: yHeight)
        addTripleCircles(yHeight: yHeight, variableradius: 250)
    }
    
    

//: ### Circle Obstacle
    let scoreLabel = SKLabelNode()
    var score = 0
//: ### Function to add Obstacles
    func addObstacle() {
        
        var i = 200
        var lol = 0
        while lol < 100{
            let x = Int.random(in: 0...12)
            switch x {
            case 0:
                addSquare(yHeight: i, width: 400)
                i += 900

            case 1:
                addCircle(yHeight: i, radius: 160, rotation: -2.0)
                i += 900

            case 2:
                addDoubleCross(yHeight: i)
                i += 900
            case 3:
                addDoubleSquare(yHeight: i, variableradius: 450)
                i += 900
            case 5:
                addSquareCircle(yHeight: i, circleRadius: 160, rectangleSize: 500)
                i += 1500
            case 6:
                addCross(yHeight: i)
                i += 900
            case 7:
                addTripleCircles(yHeight: i, variableradius: 250)
                i += 900
            case 8:
                addInvertedCross(yHeight: i)
                i += 900
            case 9:
                addInvertedSquare(yHeight: i, width: 400)
                i += 900
            case 10:
                addInvertedCircle(yHeight: i, radius: 160, rotation: 2.0)
                i += 900
            case 11:
                if i >= 10000 {
                    addCrossCircle(yHeight: i)
                    i += 900
                }

            default:
                print("NUll")
            }
            lol += 1
        }
            
        
    }
    
    let colours = [UIColor.yellow, UIColor.red, UIColor.blue, UIColor.purple]
//: ### Movement of Player
    public override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = -22
        
        addPlayer(colour: .red)
        nodeInit()
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = player.position
        scoreLabel.position = CGPoint(x: 0, y: 500)
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 100
        scoreLabel.text = String(score)
        backButtonLabel.fontColor = .white
        backButtonLabel.position = CGPoint(x: 300, y: 600)
        backButtonLabel.fontSize = 50
        backButtonLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.position = CGPoint(x:0, y:-600)
        HighScoreLabel.fontName = "AvenirNext-Bold"
        HighScoreLabel.fontSize = 50
        HighScoreLabel.fontColor = .white
        HighScoreLabel.text = String("High Score : \(highscore)")
        backButtonLabel.text = "Back"
        cameraNode.addChild(scoreLabel)
        
        cameraNode.addChild(HighScoreLabel)
        addObstacle()
        sound(sound: "Color Jump theme", type: "m4a", loops: 1)
    }
    public override func update(_ currentTime: TimeInterval) {
        let playerPositionInCamera = cameraNode.convert(player.position, to: self)
        if playerPositionInCamera.y > 0 && !cameraNode.hasActions(){
            cameraNode.position.y = player.position.y
        }
        if player.position.y <= -750 {
            player.physicsBody?.isDynamic = true
            player.physicsBody?.velocity.dy = 600.0
        }
        pauseButton.position.y = cameraNode.position.y + 525
        backbuttonlogo.position.y = cameraNode.position.y + 525
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if location.y >= 400 && location.x >= 250{
                print("Hello")
            }else{
                player.physicsBody?.velocity.dy = 700.0
            }
        }
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "pauseButton" {
                if self.view?.isPaused == true {
                    self.view?.isPaused = false
                } else if self.view?.isPaused == false {
                    self.view?.isPaused = true
                }
                
                
                
                
            }else if nodesArray.first?.name == "backbuttonlogo"{
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "MenuScene")
                gameScene!.scaleMode = .aspectFill
                self.view?.presentScene(gameScene!,transition: transition)
                self.view?.backgroundColor = UIColor.white
            }
        }
        
    }
//: ### Color Jump Music
    var arrayOfPlayers = [AVAudioPlayer]()
    func sound(sound: String, type: String, loops: Int) {
        do {
            if let bundle = Bundle.main.path(forResource: sound, ofType: type) {
                let alertSound = NSURL(fileURLWithPath: bundle)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
                try AVAudioSession.sharedInstance().setActive(true)
                let audioPlayer = try AVAudioPlayer(contentsOf: alertSound as URL)
                audioPlayer.numberOfLoops = loops
                arrayOfPlayers.append(audioPlayer)
                arrayOfPlayers.last?.prepareToPlay()
                arrayOfPlayers.last?.play()
            }
        } catch {
            print(error)
        }
    }
    
}
