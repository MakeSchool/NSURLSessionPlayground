//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
import Gloss

XCPSetExecutionShouldContinueIndefinitely()

/*
  Basic Image Download
*/

let imageView = UIImageView()

let url = NSURL(string: "http://www.sbs.com.au/news/sites/sbs.com.au.news/files/styles/full/public/g1369638954952825892.jpg.png?itok=eI4dUGhC&mtime=1429064409")!
let urlRequest = NSURLRequest(URL: url)

let session = NSURLSession.sharedSession()
let task = session.dataTaskWithRequest(urlRequest) { data, response, error in
  if let data = data {
    let image = UIImage(data: data)
    dispatch_async(dispatch_get_main_queue()) {
      print("setting image")
      imageView.image = image
    }
  }
}

task.resume()


/*
JSON Post Request
*/

struct Post: Glossy {
  var title: String?
  var content: String?
  
  init?(json: JSON) {
    self.title = "title" <~~ json
    self.content = "content" <~~ json
  }
  
  init(title: String, content: String) {
    self.title = title
    self.content = content
  }
  
  func toJSON() -> JSON? {
    return jsonify([
      "title" ~~> self.title,
      "content" ~~> self.content
      ])
  }
}

let jsonPost = Post(title: "Test", content: "Test Content").toJSON()!
let jsonData = try! NSJSONSerialization.dataWithJSONObject(jsonPost, options: NSJSONWritingOptions(rawValue: 0))

let urlPost = NSURL(string: "http://jsonplaceholder.typicode.com/posts")!
let urlRequestPost = NSMutableURLRequest(URL: urlPost)
urlRequestPost.HTTPMethod = "POST"
urlRequestPost.HTTPBody = jsonData
urlRequestPost.setValue("application/json", forHTTPHeaderField: "content-type")

let postTask = session.dataTaskWithRequest(urlRequestPost) { data, response, error in
  if let data = data {
    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
    let post = Post(json: json as! JSON)
    print(post)
  }
}

postTask.resume()
