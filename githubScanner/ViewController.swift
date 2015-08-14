//
//  ViewController.swift
//  githubScanner
//
//  Created by Russell Schmidt on 8/12/15.
//  Copyright (c) 2015 RussellSchmidt.net. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var repositories = [Repository]()
  var query: String?

  @IBOutlet var myTableView: UITableView!

  @IBOutlet var searchTextBox: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    // learn+swift+language:swift&sort=stars&order=desc is the search query
    let githubQueryURL = "https://api.github.com/search/repositories?q="
    self.query = "learn+swift+language:swift&sort=stars&order=desc"
    let queryString = githubQueryURL+self.query!
    // 1 create a NSURL object that points to the github query
    let repositoryQueryURL = NSURL(string: "\(queryString)")

    // 2 submit the query and save the data to a variable
    if let JSONData = NSData(contentsOfURL: repositoryQueryURL!) { // note the bang
      // 3 if we made a connection, unwrap the data into a Dictionary
      if let json = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: nil) as? NSDictionary {
        // 4 we need to go one level deeper to an array of dictionaries in the data 
        if let repositoryArray = json["items"] as? [NSDictionary] {
          // 5 loop over the array, instantiating the Repository object for each and adding to the repositories array
          for item in repositoryArray {
            repositories.append(Repository(json: item))
          }
        }
      }
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    self.myTableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /* 
=============== Table Views
  */

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  // set headers
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return query
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    return repositories.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    var cell = tableView.dequeueReusableCellWithIdentifier("githubCell", forIndexPath: indexPath) as! UITableViewCell

    cell.textLabel?.text = repositories[indexPath.row].name
    cell.detailTextLabel?.text = repositories[indexPath.row].description

    return cell
  }

  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    // segue = "detailSegue"
    let data = repositories[indexPath.row]
    self.performSegueWithIdentifier("detailSegue", sender: data)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "detailSegue" {
      if let selectedRowIndex = myTableView.indexPathForSelectedRow() {
      // instantiate the ViewController
        let detailVC = segue.destinationViewController as! DetailViewController
        // set the destination viewcontroller object to the info we are passing
        detailVC.repoDetail = repositories[selectedRowIndex.row]
      }
    }
  }

  /*
====================== Search
  */

  @IBAction func search(sender: AnyObject) {
    var userQuery = self.searchTextBox.text
    var charArray = [Character]()
    // "learn+swift+language:swift&sort=stars&order=desc"
    // swap blank spaces for +
    // deal with the :swift
    // deal with the &sort=stars&order=desc --- though you might just keep that and tack it on at the end

    for character in userQuery {
      if character == " " {
        charArray.append("+")
      } else {
        charArray.append(character)
      }
    }

    userQuery = String(charArray)

    query = userQuery
    let githubQueryURL = "https://api.github.com/search/repositories?q="
    let queryString = githubQueryURL+query!
    let repositoryQueryURL = NSURL(string: "\(queryString)")

    // clear out the entries from the last search
    repositories.removeAll(keepCapacity: false)

    // 2 submit the query and save the data to a variable
    if let JSONData = NSData(contentsOfURL: repositoryQueryURL!) { // note the bang
      // 3 if we made a connection, unwrap the data into a Dictionary
      if let json = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: nil) as? NSDictionary {
        // 4 we need to go one level deeper to an array of dictionaries in the data
        if let repositoryArray = json["items"] as? [NSDictionary] {
          // 5 loop over the array, instantiating the Repository object for each and adding to the repositories array
          for item in repositoryArray {
            repositories.append(Repository(json: item))
          }
        }
      }
    }
    self.myTableView.reloadData()
  }


}