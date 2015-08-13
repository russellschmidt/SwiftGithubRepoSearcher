//
//  DetailViewController.swift
//  githubScanner
//
//  Created by Russell Schmidt on 8/12/15.
//  Copyright (c) 2015 RussellSchmidt.net. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var repoTitle: UILabel!
  @IBOutlet weak var repoDescription: UILabel!
  @IBOutlet weak var repoWebView: UIWebView!

  var repoDetail: Repository?

    override func viewDidLoad() {
      super.viewDidLoad()

        // Do any additional setup after loading the view.

      self.repoTitle?.text = repoDetail?.name
      self.repoDescription?.text = repoDetail?.description

      var link = repoDetail?.html_url
      // this is to put the link we passed into the page
      if link != nil {
        let url = NSURL (string: link!)
        let requestURLObject = NSURLRequest(URL: url!)
        self.repoWebView.loadRequest(requestURLObject)
      } else {
        let url = NSURL (string: "http://www.github.com")
        let requestURLObject = NSURLRequest(URL: url!)
        self.repoWebView.loadRequest(requestURLObject)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func swipeLeftToDismiss(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

}
