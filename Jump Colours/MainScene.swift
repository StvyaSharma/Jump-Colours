//
//  MainScene.swift
//  Jump Colours
//
//  Created by Stvya Sharma on 22/05/21.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var newGameButton:SKSpriteNode!
    var exitButton:SKSpriteNode!
    var shopSkinButton:SKSpriteNode!
   
    
    override func didMove(to view: SKView) {
        
        nodeInit()
     
        
        
        
        
    }
    
    func nodeInit() {
        newGameButton = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        exitButton = self.childNode(withName: "exitButton") as? SKSpriteNode
        
        shopSkinButton = self.childNode(withName: "shopSkinButton") as? SKSpriteNode



     
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameSelection = SKScene(fileNamed: "GameScene")
                gameSelection!.scaleMode = .aspectFill
                self.view?.presentScene(gameSelection!,transition: transition)
                
            } else if nodesArray.first?.name == "exitButton" {
                exit(0)
            } else if nodesArray.first?.name == "shopSkinButton" {
                exit(0)
        }
    }
    
  

}
}

