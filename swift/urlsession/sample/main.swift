//
//  main.swift
//  sample
//
//  Created by API4AI Team on 05/05/2022.
//

import Foundation
extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}


// Use "demo" mode just to try api4ai for free. Free demo is rate limited.
// For more details visit:
//   https://api4.ai
//
// Use "rapidapi" if you want to try api4ai via RapidAPI marketplace.
// For more details visit:
//   https://rapidapi.com/api4ai-api4ai-default/api/brand-recognition/details
let MODE = "demo"


// Your RapidAPI key. Fill this variable with the proper value if you want
// to try api4ai via RapidAPI marketplace.
let RAPIDAPI_KEY = ""


let OPTIONS = [
    "demo": [
        "url": "https://demo.api4ai.cloud/brand-det/v2/results?detailed=True",
        "headers": [
            "A4A-CLIENT-APP-ID": "sample"
        ] as NSMutableDictionary
    ],
    "rapidapi": [
        "url": "https://brand-recognition.p.rapidapi.com/v2/results?detailed=True",
        "headers": [
            "X-RapidAPI-Key": RAPIDAPI_KEY
        ] as NSMutableDictionary
    ]
]


// Prepare http body with image or url.
let image = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "https://storage.googleapis.com/api4ai-static/samples/brand-det-2.jpg"
var httpBody: Data;
if (image.contains("://")) {
    // POST image via URL.
    httpBody = NSData(data: "url=\(image)".data(using: String.Encoding.utf8)!) as Data
}
else {
    // POST image as file.
    let boundary = (UUID().uuidString) // multipart boundary
    let fileLocalURL = URL(fileURLWithPath: image) // path to image file as URL object
    let mutableData = NSMutableData()
    mutableData.appendString("--\(boundary)\r\n")
    mutableData.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileLocalURL.lastPathComponent)\"\r\n\r\n")
    mutableData.append(try! Data(contentsOf: fileLocalURL))
    mutableData.appendString("\r\n")
    mutableData.appendString("--\(boundary)--")
    (OPTIONS[MODE]!["headers"] as! NSMutableDictionary)["Content-Type"] = "multipart/form-data; boundary=\(boundary)"  // add content type with boundary to headers
    httpBody = mutableData as Data
}

// Prepare request.
var request = URLRequest(url: URL(string: OPTIONS[MODE]!["url"] as! String)!)
request.httpMethod = "POST"
request.allHTTPHeaderFields = OPTIONS[MODE]!["headers"] as? [String:String]
request.httpBody = httpBody

// Semaphore to wait until request is done.
let sem = DispatchSemaphore(value: 0)

// Perform request.
let session = URLSession.shared
let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
    if (error != nil) {
        print(error!)
    } else {
        do {
            let raw = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("💬 Raw response:\n\(raw ?? "")\n")

            // Try to parse result from response data as JSON.
            let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
            let result = (json["results"] as! [[String:Any]])[0]

            // Parse and pring status.
            let status = result["status"] as! [String:String]
            if (status["code"] == "ok") {
                // Parse data.
                print("💬 Recognized brands with probabilities:")
                let entity = (result["entities"] as! [[String:Any]])[0]
                let brands = entity["array"] as! [[String: String]]
                for brand in brands {
                    let name = brand["name"] as! String
                    let size_category = brand["size_category"] as! String
                    print("  - \(name): \(size_category)")
                }
            }
        } catch {
            print(error)
        }
    }
    sem.signal()
})
dataTask.resume()

// Wait for request is done.
sem.wait()
