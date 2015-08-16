//
//  DetailViewController.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var paletteView: PaletteView!

    @IBOutlet var reverseButton: UIBarButtonItem!
    @IBOutlet var verticalButton: UIBarButtonItem!
    @IBOutlet var bayesianButton: UIBarButtonItem!
    @IBOutlet var circleButton: UIBarButtonItem!
    
    
    var palette: Palette? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        guard let palette = self.palette else {
            print("palette not assigned")
            return
        }
        guard let _ = self.view else {
            print("ViewHeirachy not loaded")
            return
        }
        
        self.title = palette.title
        
        reverseButton?.enabled = true
        verticalButton?.enabled = true
        bayesianButton?.enabled = true
        circleButton?.enabled = true
        
        paletteView?.palette = palette
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func bayesian(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.bayesianStrategy
    }
    
    @IBAction func vertical(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.verticalStrategy
    }
    
    @IBAction func circular(sender: UIBarButtonItem?) {
        paletteView?.strategy = paletteView.circularStrategy
    }
    
    @IBAction func reverse(sender: UIBarButtonItem?) {
        paletteView?.reverse = !paletteView.reverse
    }
    

}

