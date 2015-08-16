//
//  ColourTableViewController.swift
//  MosaicSample
//
//  Created by SFurlani on 8/14/15.
//  Copyright © 2015 Strong Fortress. All rights reserved.
//

import UIKit

class ColourTableViewController: UIViewController {
    
    let detailSegueIdentifier = "showDetail"
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var detailViewController: DetailViewController? = nil
    
    var dataSource: ColourListPresenter!
    
    var canCallNext: Bool = true

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataSource = ColourListPresenter(tableView: tableView)
        tableView.delegate = self;
        canCallNext = false
        dataSource.next { (nextPalettes: [Palette]) -> () in
            self.canCallNext = true
        }
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
    
    func prepareForDetailSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            print("Nothing Selected")
            return
        }
        
        guard let nav = segue.destinationViewController as? UINavigationController else {
            print("Not a NavVC: \(segue.destinationViewController)")
            return
        }
        
        guard let destination = nav.viewControllers.first as? DetailViewController else {
            print("Not a DetailVC: \(nav.viewControllers)")
            return
        }
        
        destination.palette = dataSource.palettes[indexPath.row]
    }
}

extension ColourTableViewController : UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(detailSegueIdentifier, sender: .None)
    }

}

extension ColourTableViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard canCallNext else {
            // too noisy to print
            return
        }
        
        guard let halfScreen = self.view.window?.frame.height else {
            print("Trying to update view with no window?")
            return
        }
        
        guard scrollView.contentOffset.y > scrollView.contentSize.height - halfScreen else {
            // too noisy to print
            return
        }
        
        canCallNext = false
        dataSource.next { (nextPalettes: [Palette]) -> () in
            self.canCallNext = true
        }
        
    }
}


