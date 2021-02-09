//
//  ViewController.swift
//  DemoProject
//
//  Created by AryaOmnitalk MDA on 09/02/21.
//  Copyright © 2021 ProgrammingWithSwift. All rights reserved.
//

import UIKit

struct BookData: Codable {
    let bookid, booktitle, booksubtitle, bookDesc: String
    
    enum CodingKeys: String, CodingKey {
        case bookid = "Bookid"
        case booktitle = "Booktitle"
        case booksubtitle = "Booksubtitle"
        case bookDesc = "BookDesc"
    }
}

class ViewController: UIViewController {
    @IBOutlet var tblView: UITableView!
    
    var bookArr = [BookData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        if let localData = self.readLocalFile(forName: "data") {
            self.parse(jsonData: localData)
        }
    }
    
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    private func parse(jsonData: Data) {
        do {
            bookArr = try JSONDecoder().decode([BookData].self,
                                               from: jsonData)
            
            for json in bookArr {
                print("Title: ", json.booktitle)
                print("Description: ", json.bookDesc)
                print("===================================")
            }
            
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            
        } catch {
            print("decode error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tblView.indexPathForSelectedRow {
                let controller = segue.destination as! DeatilsViewController
                controller.selectedBookName = bookArr[indexPath.row].booktitle
                controller.selectedBookDescription = bookArr[indexPath.row].bookDesc
            }
        }
    }
    
    @IBAction func LogoutAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loginstatus")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BookCell
        cell.bookIdLabel.text = bookArr[indexPath.row].bookid
        cell.bookNameLabel.text = bookArr[indexPath.row].booktitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self )
    }
}
