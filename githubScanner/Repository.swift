//
//  Repository.swift
//  githubScanner
//
//  Created by Russell Schmidt on 8/12/15.
//  Copyright (c) 2015 RussellSchmidt.net. All rights reserved.
//

import Foundation
import UIKit

class Repository {
  var name: String?
  var description: String?
  var html_url: String?

  init(json: NSDictionary) {
    self.name = json["name"] as? String
    self.description = json["description"] as? String
    self.html_url = json["html_url"] as? String
  }
}