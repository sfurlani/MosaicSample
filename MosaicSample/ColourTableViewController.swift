//
//  ColourTableViewController.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class ColourTableViewController: UIViewController {
    
    /// segue Identifier for displaying the Palette
    let detailSegueIdentifier = "showDetail"
    
    // MARK: - Properties
    
    var detailViewController: DetailViewController? = nil
    
    /// The Presenter which fetches data from the API and converts it into `Palette` structs
    /// - warning: Forced Unwrapping OK as long as initialized in `viewDidLoad()`
    var dataSource: ColourListPresenter!
    
    /// De-Bounce Downloads while the user is scrolling
    var canCallNext: Bool = true
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataSource = ColourListPresenter(tableView: tableView)
        tableView.delegate = self;
        
        loadNextBatchOfPalettes()
    }

    override func viewWillAppear(animated: Bool) {
        
        if let selectedPath = tableView.indexPathForSelectedRow where splitViewController!.collapsed {
            tableView.deselectRowAtIndexPath(selectedPath, animated: animated)
        }
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    /// - throws: `assertionFailure`'s that should never be true in production
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let identifier = segue.identifier else {
            assertionFailure("Missing Identifier: \(segue)")
            return
        }
        
        switch identifier {
        case detailSegueIdentifier:
            prepareForDetailSegue(segue, sender: sender)
        default:
            assertionFailure("Unrecognized Segue: \(identifier)")
        }
    }
    
    /// Encapsulates logic for navigating to the Palette's Detail Screen.
    /// - throws: `assertionFailure`'s that should never be true in production
    func prepareForDetailSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            assertionFailure("Nothing Selected")
            return
        }
        
        guard let nav = segue.destinationViewController as? UINavigationController else {
            assertionFailure("Not a NavVC: \(segue.destinationViewController)")
            return
        }
        
        guard let destination = nav.viewControllers.first as? DetailViewController else {
            assertionFailure("Not a DetailVC: \(nav.viewControllers)")
            return
        }
        
        destination.palette = dataSource.palettes[indexPath.row]
        self.detailViewController = destination
    }
    
    /// Load the next set of  Palettes
    /// - note: Debounces using property `canCallNext`
    /// - warning: Makes async network call that updates `tableView`
    func loadNextBatchOfPalettes() {
        
        guard canCallNext else {
            // Failing Silently is Intended
            return
        }
        
        canCallNext = false
        dataSource.next { (nextPalettes: [Palette]) in
            self.canCallNext = true
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ColourTableViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(detailSegueIdentifier, sender: .None)
    }

}

// MARK: - UIScrollViewDelegate

extension ColourTableViewController : UIScrollViewDelegate {
    
    /// If the user has scrolled to the bottom of the screen, start loading the next set of Palettes
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard let screenSize = self.view.window?.frame.size else {
            // too noisy to print
            return
        }
        
        guard tableView.contentSize.height - tableView.contentOffset.y < screenSize.height * 1.25 else {
            // too noisy to print
            return
        }
        
        loadNextBatchOfPalettes()
        
    }
}


