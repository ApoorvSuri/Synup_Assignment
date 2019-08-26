//
//  JSONQuery.swift
import Foundation
/**
 Tool used for API calls
 */
struct JSONQuery {
    
    //MARK: SUCCESS & FAILURE CLOSURES
    
    internal typealias WebServiceSuccess = (_ json : Any?) -> Void
    internal typealias WebServiceFailure = (_ error : Error? , _ data : Any?) -> Void
    
    //MARK: TIME-OUT INTERVAL
    
    public func timeoutInterval() -> TimeInterval {
        return 30
    }
    
    enum queryType : String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum httpHeaderField : String {
        case contentType = "Content-Type"
        case accept = "Accept"
    }
    
    /**
     METHOD #1 : Use this method for basic API calls like GET , POST , PUT , DELETE
     */
    public func request(withURLRequest urlRequest : URLRequest
        , successBlock : @escaping WebServiceSuccess
        , failureBlock : @escaping WebServiceFailure) {
        
        let configuration  = URLSessionConfiguration.default
        
        let session : URLSession = URLSession.init(configuration: configuration
            , delegate: nil
            , delegateQueue: OperationQueue.main)
        
        let dataTask = session.dataTask(with: urlRequest
            , completionHandler:{ data,response,error in
                
                self.handleResponse(withData: data
                    , response: response
                    , error: error
                    , successBlock: successBlock
                    , failureBlock: failureBlock)
        })
        
        dataTask.resume()
    }
    
    /**
     METHOD #2 : Use this method for Multipart API calls
     */
    public func request(withURLRequest urlRequest:URLRequest
        , data : Data
        , successBlock : @escaping WebServiceSuccess
        , failureBlock : @escaping WebServiceFailure){
        
        let configuration  = URLSessionConfiguration.default
        
        let session : URLSession = URLSession.init(configuration: configuration
            , delegate: nil
            , delegateQueue: OperationQueue.main)
        
        let uploadTask = session.uploadTask(with: urlRequest, from: data) { (data, response, error) in
            
            self.handleResponse(withData: data
                , response: response
                , error: error
                , successBlock: successBlock
                , failureBlock: failureBlock)
        }
        uploadTask.resume()
    }
    
    /**
     Use this method as a wrapper for METHOD #1
     */
    public func request(withUrl urlString : String
        , method : queryType
        , parameters : [String : Any]?
        , headers : Dictionary < String , Any >
        , successBlock : @escaping WebServiceSuccess
        , failureBlock : @escaping WebServiceFailure){
        
        let url = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        var urlRequest = URLRequest.init(url: url!
            , cachePolicy: .useProtocolCachePolicy
            , timeoutInterval: timeoutInterval())
        
        urlRequest.httpMethod = method.rawValue
        
        if method == .post || method == .put {
            urlRequest.setValue("application/json"
                , forHTTPHeaderField: httpHeaderField.contentType.rawValue)
        }
        
        if headers.keys.count > 0 {
            for key in headers.keys {
                urlRequest.setValue(headers[key] as! String?, forHTTPHeaderField: key)
            }
        }
        
        if parameters != nil && parameters!.keys.count > 0 {
            do {
                let json = try JSONSerialization.data(withJSONObject: parameters ?? [:], options: .prettyPrinted)
                urlRequest.httpBody = json
            } catch let error {
                Debug.debugPrint(items: "#Warning : JSONQuery - Error Attaching Parameters \(error.localizedDescription)")
            }
        }
        
        request(withURLRequest: urlRequest
            , successBlock: successBlock
            , failureBlock: failureBlock)
    }
    
    /**
     Use this method for handling response or an API Call
     */
    
    func handleResponse(withData data : Data?
        , response : URLResponse?
        , error : Error?
        , successBlock : @escaping WebServiceSuccess
        , failureBlock : @escaping WebServiceFailure){
        
        if response != nil {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            print("\n\nSTATUS CODE : \(statusCode)")
            
            if data != nil {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!
                        , options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    if error != nil {
                        DispatchQueue.main.async {
                            failureBlock(error , parsedData)
                        }
                    } else {
                        
                        if statusCode >= 300 || statusCode < 200{
                            DispatchQueue.main.async {
                                failureBlock(error , parsedData)
                            }
                        } else {
                            DispatchQueue.main.async {
                                successBlock(parsedData)
                            }
                        }
                    }
                } catch let error {
                    failureBlock(error , nil)
                }
            } else if error != nil {
                failureBlock(error , nil)
            } else {
                Debug.debugPrint(items: "#Warning : Bad Response \(String(describing: error?.localizedDescription))")
            }
        } else {
            failureBlock(error,nil)
        }
    }
}


/**
 Use this class for all the operations related to debugging
 */
struct Debug {
    static func debugPrint(items : Any) {
        #if DEBUG
        print(items)
        #endif
    }
}
