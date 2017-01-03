//
//  Lorem.swift
//  LoremDemo
//
//  Created by Appit on 11/14/16.
//  Copyright © 2016 Appit. All rights reserved.
//

import Foundation
import UIKit

open class Lorem {
    
    
    open static var word: String {
        return allWords.randomElement
    }
    
    open static func words(_ count: Int) -> String {
        return compose({ word }, count: count, middleSeparator: .Space)
    }
    
    open static var sentence: String {
        let numberOfWordsInSentence = Int.random(min: 4, max: 16)
        let capitalizeFirstLetterDecorator: (String) -> String = { $0.stringWithCapitalizedFirstLetter }
        return compose({ word }, count: numberOfWordsInSentence, middleSeparator: .Space, endSeparator: .Dot, decorator: capitalizeFirstLetterDecorator)
    }
    
    open static func sentences(_ count: Int) -> String {
        return compose({ sentence }, count: count, middleSeparator: .Space)
    }
    
    open static var paragraph: String {
        let numberOfSentencesInParagraph = Int.random(min: 3, max: 9)
        return sentences(numberOfSentencesInParagraph)
    }
    
    open static func paragraphs(_ count: Int) -> String {
        return compose({ paragraph }, count: count, middleSeparator: .NewLine)
    }
    
    open static var date: Date {
        let currentDate = Date()
        let currentCalendar = Calendar.current
        var referenceDateComponents = DateComponents()
        referenceDateComponents.year = -4
        let calendarOptions = NSCalendar.Options(rawValue: 0)
        let referenceDate = (currentCalendar as NSCalendar).date(byAdding: referenceDateComponents, to: currentDate, options: calendarOptions)!
        let timeIntervalSinceReferenceDate = currentDate.timeIntervalSince(referenceDate)
        let randomTimeInterval = TimeInterval(Int.random(max: Int(timeIntervalSinceReferenceDate)))
        return referenceDate.addingTimeInterval(randomTimeInterval)
    }
    
    open static var email: String {
        let delimiter = emailDelimiters.randomElement
        let domain = emailDomains.randomElement
        return "\(firstName)\(delimiter)\(lastName)@\(domain)".lowercased()
    }
    
    open static var URL: Foundation.URL {
        return Foundation.URL(string: "http://\(domains.randomElement)/")!
    }
    
    open static var tweet: String {
        return tweets.randomElement
    }
    
    
    // MARK: - Misc
    open static var title: String {
        let numberOfWordsInTitle = Int.random(min: 2, max: 7)
        let capitalizeStringDecorator: (String) -> String = { $0.capitalized }
        return compose({ word }, count: numberOfWordsInTitle, middleSeparator: .Space, decorator: capitalizeStringDecorator)
    }
    
    open static var firstName: String {
        return firstNames.randomElement
    }
    
    open static var lastName: String {
        return lastNames.randomElement
    }
    
    open static var name: String {
        return "\(firstName) \(lastName)"
    }
    
    
}


extension Lorem {
    
    class func number(length:Int = 5) -> String {
        
        guard length > 0 else {
            return ""
        }
        
        let numbers = "0123456789"
        var randomNumber:String = ""
        
        let count = numbers.characters.count
        // first number can be 0
        let charIndex = numbers.index(numbers.startIndex, offsetBy: String.IndexDistance(arc4random_uniform(UInt32(count - 1)) + 1))
        randomNumber.append(numbers[charIndex])
        // n - 1
        for _ in 1..<length {
            let charIndex = numbers.index(numbers.startIndex, offsetBy: String.IndexDistance(arc4random_uniform(UInt32(count))))
            randomNumber.append(numbers[charIndex])
        }
        
        return randomNumber
    }
    
    class func decimalNumber(lLenght:Int = 3, rLenght:Int = 2) -> String {
        
        let lNum = self.number(length: lLenght)
        let rNum = self.number(length: rLenght)
        
        let decimal = lNum + "." + rNum
        
        return decimal
    }
    
    fileprivate class func getMinimumNumber(ofLength length:Int) -> Int {
        
        var number = 1
        for _ in 1..<length {
            number = number * 10
        }
        return number
    }
    
    fileprivate class func getMaximumNumber(ofLength length:Int) -> Int {
        
        var number = 10
        for _ in 1..<length {
            number = number * 10
        }
        return number - 1
    }
    
    
    
}

fileprivate extension Lorem {
    
    fileprivate enum Separator: String {
        case None = ""
        case Space = " "
        case Dot = "."
        case NewLine = "\n"
    }
    
    fileprivate static func compose(_ provider: () -> String, count: Int, middleSeparator: Separator, endSeparator: Separator = .None, decorator: ((String) -> String)? = nil) -> String {
        var composedString = ""
        
        for index in 0..<count {
            composedString += provider()
            
            if (index < count - 1) {
                composedString += middleSeparator.rawValue
            } else {
                composedString += endSeparator.rawValue
            }
        }
        
        if let decorator = decorator {
            return decorator(composedString)
        } else {
            return composedString
        }
    }
    
    
}


fileprivate extension Lorem {
    
    fileprivate static let allWords = "alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo aspernatur aut odit aut fugit sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt neque dolorem ipsum quia dolor sit amet consectetur adipisci velit sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem ut enim ad minima veniam quis nostrum exercitationem ullam corporis nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam nisi ut aliquid ex ea commodi consequatur quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi id est laborum et dolorum fuga et harum quidem rerum facilis est et expedita distinctio nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est qui minus id quod maxime placeat facere possimus omnis voluptas assumenda est omnis dolor repellendus temporibus autem quibusdam et aut consequatur vel illum qui dolorem eum fugiat quo voluptas nulla pariatur at vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae itaque earum rerum hic tenetur a sapiente delectus ut aut reiciendis voluptatibus maiores doloribus asperiores repellat".components(separatedBy: " ")
    
    fileprivate static let firstNames = "Judith Angelo Margarita Kerry Elaine Lorenzo Justice Doris Raul Liliana Kerry Elise Ciaran Johnny Moses Davion Penny Mohammed Harvey Sheryl Hudson Brendan Brooklynn Denis Sadie Trisha Jacquelyn Virgil Cindy Alexa Marianne Giselle Casey Alondra Angela Katherine Skyler Kyleigh Carly Abel Adrianna Luis Dominick Eoin Noel Ciara Roberto Skylar Brock Earl Dwayne Jackie Hamish Sienna Nolan Daren Jean Shirley Connor Geraldine Niall Kristi Monty Yvonne Tammie Zachariah Fatima Ruby Nadia Anahi Calum Peggy Alfredo Marybeth Bonnie Gordon Cara John Staci Samuel Carmen Rylee Yehudi Colm Beth Dulce Darius inley Javon Jason Perla Wayne Laila Kaleigh Maggie Don Quinn Collin Aniya Zoe Isabel Clint Leland Esmeralda Emma Madeline Byron Courtney Vanessa Terry Antoinette George Constance Preston Rolando Caleb Kenneth Lynette Carley Francesca Johnnie Jordyn Arturo Camila Skye Guy Ana Kaylin Nia Colton Bart Brendon Alvin Daryl Dirk Mya Pete Joann Uriel Alonzo Agnes Chris Alyson Paola Dora Elias Allen Jackie Eric Bonita Kelvin Emiliano Ashton Kyra Kailey Sonja Alberto Ty Summer Brayden Lori Kelly Tomas Joey Billie Katie Stephanie Danielle Alexis Jamal Kieran Lucinda Eliza Allyson Melinda Alma Piper Deana Harriet Bryce Eli Jadyn Rogelio Orlaith Janet Randal Toby Carla Lorie Caitlyn Annika Isabelle inn Ewan Maisie Michelle Grady Ida Reid Emely Tricia Beau Reese Vance Dalton Lexi Rafael Makenzie Mitzi Clinton Xena Angelina Kendrick Leslie Teddy Jerald Noelle Neil Marsha Gayle Omar Abigail Alexandra Phil Andre Billy Brenden Bianca Jared Gretchen Patrick Antonio Josephine Kyla Manuel Freya Kellie Tonia Jamie Sydney Andres Ruben Harrison Hector Clyde Wendell Kaden Ian Tracy Cathleen Shawn".components(separatedBy: " ")
    
    fileprivate static let lastNames = "Chung Chen Melton Hill Puckett Song Hamilton Bender Wagner McLaughlin McNamara Raynor Moon Woodard Desai Wallace Lawrence Griffin Dougherty Powers May Steele Teague Vick Gallagher Solomon Walsh Monroe Connolly Hawkins Middleton Goldstein Watts Johnston Weeks Wilkerson Barton Walton Hall Ross Chung Bender Woods Mangum Joseph Rosenthal Bowden Barton Underwood Jones Baker Merritt Cross Cooper Holmes Sharpe Morgan Hoyle Allen Rich Rich Grant Proctor Diaz Graham Watkins Hinton Marsh Hewitt Branch Walton O'Brien Case Watts Christensen Parks Hardin Lucas Eason Davidson Whitehead Rose Sparks Moore Pearson Rodgers Graves Scarborough Sutton Sinclair Bowman Olsen Love McLean Christian Lamb James Chandler Stout Cowan Golden Bowling Beasley Clapp Abrams Tilley Morse Boykin Sumner Cassidy Davidson Heath Blanchard McAllister McKenzie Byrne Schroeder Griffin Gross Perkins Robertson Palmer Brady Rowe Zhang Hodge Li Bowling Justice Glass Willis Hester Floyd Graves Fischer Norman Chan Hunt Byrd Lane Kaplan Heller May Jennings Hanna Locklear Holloway Jones Glover Vick O'Donnell Goldman McKenna Starr Stone McClure Watson Monroe Abbott Singer Hall Farrell Lucas Norman Atkins Monroe Robertson Sykes Reid Chandler Finch Hobbs Adkins Kinney Whitaker Alexander Conner Waters Becker Rollins Love Adkins Black Fox Hatcher Wu Lloyd Joyce Welch Matthews Chappell MacDonald Kane Butler Pickett Bowman Barton Kennedy Branch Thornton McNeill Weinstein Middleton Moss Lucas Rich Carlton Brady Schultz Nichols Harvey Stevenson Houston Dunn West O'Brien Barr Snyder Cain Heath Boswell Olsen Pittman Weiner Petersen Davis Coleman Terrell Norman Burch Weiner Parrott Henry Gray Chang McLean Eason Weeks Siegel Puckett Heath Hoyle Garrett Neal Baker Goldman Shaffer Choi Carver".components(separatedBy: " ")
    
    fileprivate static let emailDomains = "gmail.com yahoo.com hotmail.com email.com live.com me.com mac.com aol.com fastmail.com mail.com".components(separatedBy: " ")
    
    fileprivate static let emailDelimiters = ["", ".", "-", "_"]
    
    fileprivate static let domains = "twitter.com google.com youtube.com wordpress.org adobe.com blogspot.com godaddy.com wikipedia.org wordpress.com yahoo.com linkedin.com amazon.com flickr.com w3.org apple.com myspace.com tumblr.com digg.com microsoft.com vimeo.com pinterest.com qq.com stumbleupon.com youtu.be addthis.com miibeian.gov.cn delicious.com baidu.com feedburner.com bit.ly".components(separatedBy: " ")
    
    // Source: http://www.kevadamson.com/talking-of-design/article/140-alternative-characters-to-lorem-ipsum
    fileprivate static let tweets = ["Far away, in a forest next to a river beneath the mountains, there lived a small purple otter called Philip. Philip likes sausages. The End.", "He liked the quality sausages from Marks & Spencer but due to the recession he had been forced to shop in a less desirable supermarket. End.", "He awoke one day to find his pile of sausages missing. Roger the greedy boar with human eyes, had skateboarded into the forest & eaten them!"]
}


extension Lorem {
    
    // MARK: URLs for Placeholder Images
    
    enum ImageService: String {
        
        case lorempixel = "http://lorempixel.com"
        case hhhhold = "http://hhhhold.com"
        case dummyimage = "http://dummyimage.com"
        case placekitten = "http://placekitten.com"
    }
    
    class func imageUrl(withSize size:CGSize, service:ImageService) -> String {
        
        let baseUrlString = prepareImageUrl(fromService: service)
        let sizeString = "/\(Int(size.width))/\(Int(size.height))/"
        let fullUrlString = baseUrlString + sizeString
        
        return fullUrlString
    }
    
    fileprivate class func prepareImageUrl(fromService service:ImageService) -> String {
        
        switch service {
        case .lorempixel:
            return ImageService.lorempixel.rawValue
        case .hhhhold:
            return ImageService.lorempixel.rawValue
        case .dummyimage:
            return ImageService.lorempixel.rawValue
        case .placekitten:
            return ImageService.lorempixel.rawValue
        }
    }
    
}

extension Lorem {
    
    // ref: http://www.thinkbroadband.com/download.html
    enum FileSize:String {
        
        case MB_5 = "5MB"
        case MB_10 = "10MB"
        case MB_20 = "20MB"
        case MB_50 = "50MB"
        case MB_100 = "100MB"
        case MB_200 = "200MB"
        case MB_512 = "512MB"
        case GB_1 = "1GB"
    }
    
    class func fileUrl(withSize size:FileSize) -> String {
        
        let baseFileUrl = "http://download.thinkbroadband.com"
        let fileUrlString = baseFileUrl + "/\(size.rawValue).zip"
        
        return fileUrlString
    }
    
}

extension Lorem {
    
    class func words(count:Int, seperatedBy seperator:String) -> String {
        
        var words:String = self.words(1)
        for _ in 1..<count {
            
            words.append(seperator)
            words.append(self.words(1))
        }
        
        return words
    }
    
    class func numbers(count:Int, seperatedBy seperator:String) -> String {
        
        var words:String = self.number()
        for _ in 1..<count {
            
            words.append(seperator)
            words.append(self.number())
        }
        
        return words
    }
    
    class func list(numberOfItems:Int, wordsCount:Int = 1) -> [String] {
        
        var list = [String]()
        for _ in 1...numberOfItems {
            let item = self.words(wordsCount)
            list.append(item)
        }
        return list
    }
    
    
}

extension Lorem {
    
    
    class func time() -> String {
        
        let date = self.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: date)
        return time
    }
    
    class func dateString() -> String {
        
        let date = self.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "eee, dd MMM YY"
        let time = formatter.string(from: date)
        return time
    }

}




private extension Int {
    
    static func random(min: Int = 0, max: Int) -> Int {
        assert(min >= 0)
        assert(min < max)
        
        arc4random()
        
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
}

private extension Array {
    
    var randomElement: Element {
        return self[Int.random(max: count - 1)]
    }
    
}

private extension String {
    
    var stringWithCapitalizedFirstLetter: String {
        let firstLetterRange = startIndex..<characters.index(after: startIndex)
        let capitalizedFirstLetter = substring(with: firstLetterRange).capitalized
        return replacingCharacters(in: firstLetterRange, with: capitalizedFirstLetter)
    }
    
}



