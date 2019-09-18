//
//  ViewController.swift
//  Bitcoin_Tracker
//
//  Created by apple on 18/09/19.
//  Copyright © 2019 VasilisGreen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
 
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySelected = ""

    
    @IBOutlet weak var currentBitPrice: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    
    // MARK: - DELEGATES - PICKER
    /**********************************************************************************************/
    
    // determines how many columns we want in out picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // determines the number of rows in our picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // give title names to our picker rows
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // tells the picker what to do when the user selects a particular row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencyArray[row]
        getCurencyValues(url: finalURL)
        
    }
    
    
    
    // MARK: - ALAMOFIRE - API CALL
    /**********************************************************************************************/
    
    func getCurencyValues(url: String) {
        Alamofire.request(url, method: .get).responseJSON{
            response in
            if response.result.isSuccess {
                print("Success")
                print(response)
                
                let currencyJSON: JSON = JSON(response.result.value!)
                self.updateCoinCurrency(json: currencyJSON)
             
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.currentBitPrice.text = "Connection Issues?"
            }
        }
    }
    
    
    
    // MARK: - SWIFTY JSON - PARESE JSON
    /**********************************************************************************************/
    func updateCoinCurrency (json: JSON) {
        
        if let currencyResult = json["ask"].double {
            currentBitPrice.text = currencySelected + String(currencyResult)
        } else {
            currentBitPrice.text = "Price Unavailable"
        }
        
    }
    

}

