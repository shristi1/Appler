//
//  ScoreKeeper.swift
//  GWC Starter Code
//
//  Created by Sophia Blitz on 1/25/18.
//  Copyright © 2018 Shristi. All rights reserved.
//

import Foundation

class ScoreKeeper{
    var currentScore: Int = 0
    var highScore: Int  = 0
    
    //read the score
    func getScore() -> Int{
        //print("current score: ", currentScore) //DEBUG
        return currentScore;
    }
    //read the score
    func getHighScore() -> Int{
        //print("high score: ", highScore) //DEBUG
        return highScore;
    }
    
    //increase score
    func increaseScore (){
        currentScore = 1 + currentScore;
        if currentScore>highScore{
            highScore = currentScore
        }
        //print("current score: ", currentScore) //DEBUG
    }
    //decrease score
    func decreaseScore() {
        currentScore = currentScore - 1
        //print("current score: ", currentScore) //DEBUG
    }
    //silver food score
    func addSilverFoodScore(){
        currentScore = currentScore + 3
        //print("current score: ", currentScore) //DEBUG
    }
    //gold food score
    func addGoldFoodScore(){
        currentScore = currentScore + 5
        //print("current score: ", currentScore) //DEBUG
    }
    // reset the score
    func resetScore(){
        currentScore = 0
    }
    //detemine score color
    func getScoreColor()-> String{
        if(currentScore <= 5)
        {
            //print("score color: red") //DEBUG
            return "red"
        }
        else if (currentScore <= 15)
        {
           // print("score color: yellow") //DEBUG
            return "yellow"
        }
        else
        {
            //print("score color: green") //DEBUG
            return "green"
        }
        
    }
    
}
