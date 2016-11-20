//
//  GlyphEntryVC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class GlyphEntryVC: UIViewController {
    // datamodel
    public var subject: Subject?
    public var segueId: String?
    
    private var glyphs = [Glyph]()
    
    @IBOutlet weak var glyphView: GlyphView!
    
    private var characterToBeDrawn = [String]()
    let synthesizer = AVSpeechSynthesizer()

    
    func randomNumbers(range: Range<Int>) -> [Int] {
        let min = range.lowerBound
        let max = range.upperBound
        
        var unshuffledNumbers = [Int]()
        
        for _ in 1..<2 {
            unshuffledNumbers.append(contentsOf: Array(min..<max))
        }
        
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: unshuffledNumbers)
        return shuffledNumbers as! [Int]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subject?.description ?? "invalid")

//        synthesizer.speak(AVSpeechUtterance(string: "Please draw the following numbers using your index finger"))
        characterToBeDrawn = randomNumbers(range: 0..<3).map {"\($0)"}
        print("\(characterToBeDrawn)")
        newInstruction()
    }
    
    func newInstruction() {
        if let character = characterToBeDrawn.last
        {
            let newGlyph = Glyph(context: (self.subject?.managedObjectContext)!)
            newGlyph.character = character
//            synthesizer.speak(AVSpeechUtterance(string: character))
            self.glyphs.append(newGlyph)
            characterToBeDrawn.removeLast()
            self.glyphView.glyph = newGlyph
            newGlyph.clientWidth = Double(self.glyphView.bounds.size.width)
            newGlyph.clientHeight = Double(self.glyphView.bounds.size.height)
            
        } else {
            self.glyphView.isUserInteractionEnabled = false
            for glyph in self.glyphs {
                self.subject?.addToGlyphs(glyph)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.performSegue(withIdentifier: self.segueId!, sender: self)
        }
    }
    
    @IBAction func redo(_ sender: UIButton) {
        if let glyph = glyphs.last
        {
            characterToBeDrawn.append(glyph.character!)
            self.subject?.managedObjectContext?.delete(glyph)
            glyphs.removeLast()
            newInstruction()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let destinationVC = segue.destination as? SwapFingerVC {
            destinationVC.subject = self.subject
        } else if let destinationVC = segue.destination as? SummaryVC {
            destinationVC.subject = self.subject
        }
    }
    
    
    @IBAction func nextNumber(_ sender: ProgressButton) {
        if (self.glyphView.glyph?.strokes?.count)! > 0 {
            sender.progress = CGFloat(self.glyphs.count) / CGFloat(self.glyphs.count + self.characterToBeDrawn.count)
            newInstruction()
        }
        
        print(subject?.description ?? "invalid")
    }
}
