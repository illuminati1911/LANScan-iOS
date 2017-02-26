//
//  HackerTerminal.swift
//  LANScan
//
//  Created by Ville Välimaa on 26/02/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

import UIKit

class HackerTerminal: UITextView {

    fileprivate var buffer:Array<String> = []
    fileprivate var isTyping:Bool = false
    fileprivate var timeInterval:TimeInterval?
    
    convenience init(typingDelay:TimeInterval) {
        self.init(frame: CGRect.zero)
        
        // To get line spacing. Yes, it's a hack.
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        self.attributedText = NSAttributedString(string: " ", attributes: [NSParagraphStyleAttributeName : paragraphStyle])
        
        self.backgroundColor = UIColor.black
        self.textColor = UIColor(red:0.13, green:0.76, blue:0.05, alpha:1.0)
        self.font = UIFont(name: "Press Start 2P", size: 8.0)
        self.tintColor = UIColor.green
        self.inputView = UIView(frame: CGRect.zero)
    }
    
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.width = 8
        rect.size.height = 8
        return rect
    }
    
    
    override func insertText(_ text: String) {
        self.becomeFirstResponder()
        self.buffer.append(text)
        
        guard !self.isTyping else {
            return
        }
        self.writeBufferToConsole()
    }
    
    fileprivate func writeBufferToConsole() {
        self.isTyping = true
        DispatchQueue.global(qos: .background).async {
            while self.buffer.count > 0 {
                let characters = self.buffer.remove(at: 0).characters
                characters.forEach { c in self.writeToUIAndWait(char:c) }
            }
            self.isTyping = false
        }
    }
    
    fileprivate func writeToUIAndWait(char:Character) {
        DispatchQueue.main.async {
            self.text = self.text + String(char)
        }
        Thread.sleep(forTimeInterval: self.timeInterval ?? 0.002)
    }
    

}
