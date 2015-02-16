//
//  GameScene.swift
//  Bounce
//
//  Created by Vaish Raman on 2/9/15.
//  Copyright (c) 2015 Vaishnavi Raghu Raman. All rights reserved.
//

import SpriteKit
import Foundation


//global variables :(
var PenguinTexture = SKTexture(imageNamed: "penguin.png");
var Penguin = SKSpriteNode(texture: PenguinTexture);
var Penguin2Texture = SKTexture(imageNamed: "penguin2.png");
var Penguin2 = SKSpriteNode(texture:Penguin2Texture);
let donutCategory: UInt32 = 0x1 << 0
let penguinCategory: UInt32 = 0x1 << 1
let bombCategory: UInt32 = 0x1 << 2
let penguin2Category: UInt32 = 0x1 << 3
let floorCategory: UInt32 = 0x1 << 4
var endGame = false;
var DonutTimer: NSTimer?;
var BombTimer: NSTimer?;
var scoreLabelNode:SKLabelNode!
var score = 0;
var x = CGFloat(0);
var speed = CGFloat(0);
var y = CGFloat(0);
var bombspeed = CGFloat(0);
var highscore = 0;
let action = SKAction.rotateByAngle(CGFloat(-0.0866666), duration:0.6);
let action2 = SKAction.rotateByAngle(CGFloat(0.0866666), duration:0.6);
let action3 = SKAction.playSoundFileNamed("endgame.mp3", waitForCompletion: false);
let action4 = SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false);



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        
    //Set up gravity for game
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, -17.8);
        
    //Default score value back to zero
        score = 0;
    //Update score on moniter
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 2.93 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 8
        scoreLabelNode.text = String(score)
        scoreLabelNode.fontSize = 75;
        self.addChild(scoreLabelNode)
        scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
        
    //Score Label on moniter
        let screenLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        screenLabel.text = "Score";
        screenLabel.fontSize = 25;
        screenLabel.fontColor = UIColor.whiteColor()
        screenLabel.position = CGPointMake( CGRectGetMidX( self.frame ), 10 * self.frame.size.height / 12 )
        screenLabel.zPosition = 8;
        self.addChild(screenLabel)
        
    //Add left icicle
        var leftIcicleTexture = SKTexture(imageNamed: "icicle.png");
        leftIcicleTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var lefticicle = SKSpriteNode(texture: leftIcicleTexture);
        lefticicle.setScale(1);
        lefticicle.position = CGPoint(x: self.frame.size.width * 0.15,y: self.frame.size.height * 0.69);
        lefticicle.zPosition = -7;
        lefticicle.zRotation = -3.14/2
        lefticicle.xScale = 0.47;
        self.addChild(lefticicle);
        
    //Add left icicle
        var rightIcicleTexture = SKTexture(imageNamed: "icicle.png");
        rightIcicleTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var righticicle = SKSpriteNode(texture: rightIcicleTexture);
        righticicle.setScale(1.25);
        righticicle.position = CGPoint(x: self.frame.size.width * 0.85,y: self.frame.size.height * 0.69);
        righticicle.zPosition = -7;
        righticicle.zRotation = 3.14/2
        righticicle.xScale = 0.47
        self.addChild(righticicle);

    //Add background picture 
        var backgroundTexture = SKTexture(imageNamed: "IcyBackground.png");
        backgroundTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var background = SKSpriteNode(texture: backgroundTexture);
        background.position = CGPoint(x: self.frame.size.width * 0.5,y: self.frame.size.height * 0.5);
        background.zPosition = -10;
        self.addChild(background);

        
    //Add the actual floor
        var floorTexture = SKTexture(imageNamed: "floor.png" );
        floorTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var floor = SKSpriteNode(texture: floorTexture);
        floor.position = CGPoint(x: self.frame.size.width * 0.5,y: self.frame.size.height * 0.13);
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(floor.frame.size.width, floor.frame.size.height));
        floor.setScale(1.29);
        floor.physicsBody?.affectedByGravity = false;
        floor.physicsBody?.dynamic = false;
        floor.physicsBody?.categoryBitMask = floorCategory;
        floor.physicsBody?.contactTestBitMask = penguinCategory | penguin2Category;
        floor.physicsBody?.collisionBitMask = penguinCategory | penguin2Category;


        self.addChild(floor);
        
    //Add penguin1
        Penguin.setScale(0.35);
        PenguinTexture.filteringMode = SKTextureFilteringMode.Nearest;
        Penguin.position = CGPoint(x: self.frame.size.width * 0.23,y: self.frame.size.height * 0.75);
        Penguin.physicsBody = SKPhysicsBody(circleOfRadius: Penguin.size.height/4);
        Penguin.physicsBody?.affectedByGravity = false;
        Penguin.physicsBody?.categoryBitMask = penguinCategory;
        Penguin.physicsBody?.contactTestBitMask = donutCategory | floorCategory;
        Penguin.physicsBody?.collisionBitMask = donutCategory | floorCategory;
        Penguin.zRotation = 0;
        
        self.addChild(Penguin);
        
    //Add second penguin into game
        Penguin2.setScale(0.35);
        Penguin2Texture.filteringMode = SKTextureFilteringMode.Nearest;
        Penguin2.position = CGPoint(x: self.frame.size.width * 0.77,y: self.frame.size.height * 0.75);
        Penguin2.physicsBody = SKPhysicsBody(circleOfRadius: Penguin2.size.height/3.6);
        Penguin2.physicsBody?.affectedByGravity = false;
        Penguin2.physicsBody?.categoryBitMask = penguin2Category;
        Penguin2.physicsBody?.contactTestBitMask = donutCategory | floorCategory;
        Penguin2.physicsBody?.collisionBitMask = donutCategory | floorCategory;
        Penguin2.zRotation = 0;

        self.addChild(Penguin2);
        
        Timer();
        
        DonutTimer = NSTimer.scheduledTimerWithTimeInterval(0.80, target: self, selector: Selector("CreateDonuts"), userInfo: nil, repeats: true)
        
        var BombStartTimer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("TurnOnBombs"), userInfo: nil, repeats: false)
    }
    
    func TurnOnBombs() {
        BombTimer = NSTimer.scheduledTimerWithTimeInterval(2.2, target: self, selector: Selector("CreateBombs"), userInfo: nil, repeats: true)
    }
    
    func CreateBombs() {
        
        var bombTexture = SKTexture(imageNamed: "bomb.png");
        
        var bombSide = rand() % 2;
        
        switch (bombSide){
        case (0):
            y = CGFloat(self.frame.size.width);
            bombspeed = CGFloat(-350);

        default:
            y = CGFloat(0);
            bombspeed = CGFloat(350);
        }
        
        bombTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var bomb = SKSpriteNode(texture: bombTexture);
        bomb.setScale(0.07);
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.size.height/2.5);
        var percent = rand()
        let newPercent:Int = Int(percent);
        let finalpercent: CGFloat = CGFloat(newPercent%40 + 25);
        let percentUse: CGFloat = CGFloat(finalpercent * 0.01);
        bomb.position = CGPointMake(y, self.frame.size.height * percentUse);
        bomb.physicsBody?.affectedByGravity = false;
        bomb.physicsBody?.velocity = CGVectorMake(bombspeed, 0);
        bomb.physicsBody?.categoryBitMask = bombCategory;
        bomb.physicsBody?.contactTestBitMask = penguinCategory | penguin2Category;
        bomb.physicsBody?.collisionBitMask = penguinCategory | penguin2Category;
        
        self.addChild(bomb);
        
    }
    
    func Timer(){
        var myTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("CheckPenguinPosition"), userInfo: nil, repeats: true)
   	}
    
    func CheckPenguinPosition() {
        if (Penguin.position.y < 137) {
            var myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("DeletePenguin"), userInfo: nil, repeats: false)
        }
        
        if (Penguin2.position.y < 137) {
            var myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("DeletePenguin2"), userInfo: nil, repeats: false)
        }
    }
        
        func DeletePenguin(){
            //Delete penguin from game
            Penguin.removeFromParent();
            //Add first penguin into game
            Penguin.position = CGPoint(x: self.frame.size.width * 0.23,y: self.frame.size.height * 0.75);
            Penguin.physicsBody?.affectedByGravity = false;
            Penguin.physicsBody?.categoryBitMask = penguinCategory;
            Penguin.physicsBody?.contactTestBitMask = donutCategory | floorCategory;
            Penguin.physicsBody?.collisionBitMask = donutCategory | floorCategory;
            self.addChild(Penguin);
            Penguin.runAction(SKAction.repeatAction(action, count: 1))

        }
        func DeletePenguin2(){
            //delete second penguin from game
            Penguin2.removeFromParent();
            //Add second penguin into game
            Penguin2.position = CGPoint(x: self.frame.size.width * 0.77,y: self.frame.size.height * 0.75);
            Penguin2.physicsBody?.affectedByGravity = false;
            Penguin2.physicsBody?.categoryBitMask = penguin2Category;
            Penguin2.physicsBody?.contactTestBitMask = donutCategory | floorCategory;
            Penguin2.physicsBody?.collisionBitMask = donutCategory | floorCategory;
            self.addChild(Penguin2);
            Penguin2.runAction(SKAction.repeatAction(action2, count: 1))
        }
    
    func CreateDonuts() {
        
        var donutType = rand() % 7;
        var donutTexture = SKTexture();
        switch(donutType) {
            case(0):
                //Creates chocolate donut :)
                donutTexture = SKTexture(imageNamed: "donut_a.png");
            case(1):
                //Create Vanilla donut
                donutTexture = SKTexture(imageNamed: "donut_b.png");
            case(2):
                //Create strawberry donut
                donutTexture = SKTexture(imageNamed: "donut_c.png");
            default:
                return;
        }
        var donutSide = rand() % 2;

        switch(donutSide) {
            case(0):
                x = CGFloat(self.frame.size.width);
                speed = CGFloat(-280);
            
            default:
                x = CGFloat(0);
                speed = CGFloat(280);
        }
        
        donutTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var donut = SKSpriteNode(texture: donutTexture);
        donut.setScale(0.033);
        donut.physicsBody = SKPhysicsBody(circleOfRadius: donut.size.height/2.5);
        var percent = rand()
        let newPercent:Int = Int(percent);
        let finalpercent: CGFloat = CGFloat(newPercent%40 + 25);
        let percentUse: CGFloat = CGFloat(finalpercent * 0.01);
        donut.position = CGPointMake(x, self.frame.size.height * percentUse);
        donut.physicsBody?.affectedByGravity = false;
        donut.physicsBody?.velocity = CGVectorMake(speed, 0);
        donut.physicsBody?.categoryBitMask = donutCategory;
        donut.physicsBody?.contactTestBitMask = penguin2Category | penguinCategory;
        donut.physicsBody?.collisionBitMask = penguinCategory | penguin2Category;

        self.addChild(donut);
    }
        
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = contact.bodyA;
        var secondBody = contact.bodyB;
        
    //FOR BOMB AND PENGUIN INTERACTION
        if ((((firstBody.categoryBitMask & penguin2Category) != 0) && ((secondBody.categoryBitMask & bombCategory) != 0)) || (((firstBody.categoryBitMask & bombCategory) != 0) && ((secondBody.categoryBitMask & penguin2Category) != 0)))
            
        {
            firstBody.node?.physicsBody?.dynamic = false;
            secondBody.node?.physicsBody?.dynamic = false;
            
            runAction(action3);
            
            var BombStartTimer = NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: Selector("CallEnd"), userInfo: nil, repeats: false)
            
        }
        else if ((((firstBody.categoryBitMask & penguinCategory) != 0) && ((secondBody.categoryBitMask & bombCategory) != 0)) || (((firstBody.categoryBitMask & bombCategory) != 0) && ((secondBody.categoryBitMask & penguinCategory) != 0)))
            
        {
            firstBody.node?.physicsBody?.dynamic = false;
            secondBody.node?.physicsBody?.dynamic = false;
            

            runAction(action3);
            
            var BombStartTimer = NSTimer.scheduledTimerWithTimeInterval(1.1, target: self, selector: Selector("CallEnd"), userInfo: nil, repeats: false)

        }
        
    // FOR DONUT AND PENGUIN INTERACTION
        if ((((firstBody.categoryBitMask & penguin2Category) != 0) && ((secondBody.categoryBitMask & donutCategory) != 0)) || (((firstBody.categoryBitMask & donutCategory) != 0) && ((secondBody.categoryBitMask & penguin2Category) != 0)))
        
        {
            score++;
            runAction(action4);
            if (firstBody == Penguin.physicsBody || firstBody == Penguin2.physicsBody)
            {
                secondBody.node?.removeFromParent();
                //TODO: First body is the penguin reset its position
                
            }
            else
            {
                //TODO: Second body is the penguin reset its position
                firstBody.node?.removeFromParent();
            }
            UpdateScore();
            
            //self.addChild(Penguin2);
            
            
            
            
            
           
            

            
        }
        else if ((((firstBody.categoryBitMask & penguinCategory) != 0) && ((secondBody.categoryBitMask & donutCategory) != 0)) || (((firstBody.categoryBitMask & donutCategory) != 0) && ((secondBody.categoryBitMask & penguinCategory) != 0)))
        
        {
            firstBody.node?.removeFromParent();
            secondBody.node?.removeFromParent();
            score++;
            self.addChild(Penguin);
            
            
            let action3 = SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false)
            runAction(action3);
            
            
            UpdateScore();

            
        }
        
    }
    
    func CallEnd(){
        self.removeAllChildren();
        EndGameDispaly();
    }
    
    func UpdateScore() {
        
        //delete old score first
        scoreLabelNode.removeFromParent();
    
        //add new updated score
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ), 2.93 * self.frame.size.height / 4 )
        scoreLabelNode.zPosition = 8
        scoreLabelNode.text = String(score)
        scoreLabelNode.fontSize = 75;
        self.addChild(scoreLabelNode)
        scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
    }
    func EndGameDispaly() {
        self.removeAllChildren();
        DonutTimer?.invalidate();
        BombTimer?.invalidate();
        
        
        var EndScreenTexture = SKTexture(imageNamed: "EndScreen.png")
        EndScreenTexture.filteringMode = SKTextureFilteringMode.Nearest;
        var EndScreen = SKSpriteNode(texture: EndScreenTexture);
        EndScreen.position = CGPoint(x: self.frame.size.width * 0.5,y: self.frame.size.height * 0.5);
        EndScreen.zPosition = 10;
        EndScreen.setScale(0.77);
    
        self.addChild(EndScreen);
        var myScore = String(score)
        let myLabel = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        myLabel.text = myScore;
        myLabel.fontSize = 85;
        myLabel.fontColor = UIColor.grayColor()
        myLabel.position = CGPoint(x: self.frame.size.width * 0.58, y: self.frame.size.height * 0.430);
        myLabel.zPosition = 20;
        self.addChild(myLabel)
        
        if (score > highscore){
            highscore = score;
        }
        
        var HighestScore = String(highscore)
        let myLabel2 = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        myLabel2.text = HighestScore;
        myLabel2.fontSize = 55;
        myLabel2.fontColor = UIColor.grayColor()
        myLabel2.position = CGPoint(x: self.frame.size.width * 0.58, y: self.frame.size.height * 0.330);
        myLabel2.zPosition = 20;
        self.addChild(myLabel2)

        endGame = true;
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        if (endGame == true) {
            endGame = false;
            self.removeAllChildren();
            didMoveToView(SKView.self());
        }
        else {
            let touch = touches.anyObject() as UITouch
            let touchLocation = touch.locationInNode(self)
            for touch: AnyObject in touches {
                if (touchLocation.x < self.frame.size.width * 0.5 ){
                    Penguin.physicsBody?.applyImpulse(CGVectorMake(0, 18.0));
                    Penguin.physicsBody?.affectedByGravity = true;
                }
                else {
                    Penguin2.physicsBody?.applyImpulse(CGVectorMake(0, 18.0));
                Penguin2.physicsBody?.affectedByGravity = true;
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
