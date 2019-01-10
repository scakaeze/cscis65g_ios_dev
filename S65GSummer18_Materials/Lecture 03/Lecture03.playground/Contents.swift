//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


typealias Position = (row: Int, col: Int)

var x: Position = (row: 1, col: 2)

typealias Doubler = (Int) -> Int

var doubler: Doubler = {
   $0 * 2
}

doubler(4)

var i: Int = 5
i / 2
i % 2

( 4+1 ) % 5
( 4 + 2 ) % 5
( 4 + 17894867839) % 5
((( 0 - 4 ) % 5 ) + 5 ) % 5

var b: Bool = (1 == 1) ? true : false
i = ( i == 1 ) ? 14 : 15

var a : Array<Int> = [1,2,3]
var a2: [Int] = [3,4,5]

var a3: Array<Array<Int>> = [[1,2,3],[4,5,6,7]]
var a4: [[Int]] = a3

a4.append([7,8,9])

a4.append([19])
a4.count
a4[3]
a4[3][0]
a4[3][0] = 49
a4[3][0]
print(a4)

if a4[3][0] > 14 {
    a4[2][1] = 24
} else {
    a4[1][0] = 13
}

a4

doubler = {
    guard $0 > 38 else { return -1 }
    return $0 * 2
}
doubler(40)
doubler(30)

struct Person {
    var lastName: String = ""
    var firstName: String = ""
    var age: Int = 0
    
    var description: String {
        return "\(lastName), \(firstName)"
    }
    
    init(fullName: String) {
        let components = fullName.split(separator: ",")
        guard components.count > 0 else {
            return
        }
        lastName = String(components[0])
        guard components.count > 1 else {
            return
        }
        firstName = String(components[1])
        age = 40
    }
    
    func multiplier(_ m: Int) -> Int {
        return age * m
    }
}

var van = Person(fullName: "Simmons, Van")
let mAge = van.multiplier(2)
van.description
van.lastName
van.firstName
van.age

let van3 = van
van.age = 20
van3.age


let denise = Person(fullName: "Francisco, Denise")
denise.description

class Person2 {
    var lastName: String = ""
    var firstName: String = ""
    var age: Int = 0
    
    var description: String {
        return "\(lastName), \(firstName)"
    }
    
    init(fullName: String?) {
        guard let fullName = fullName else { return }
        let components = fullName.split(separator: ",")
        guard components.count > 0 else {
            return
        }
        lastName = String(components[0])
        guard components.count > 1 else {
            return
        }
        firstName = String(components[1])
        age = 40
    }
    
    func multiplier(_ m: Int) -> Int {
        return age * m
    }
}

let van2 = Person2(fullName: "Simmons, Van")
van2.description

let van4 = van2
van2.age = 20
van4.age

//enum Maybe {
//    case some(Double)
//    case none
//}
//
//func logarithm(_ value: Double) -> Maybe {
//    guard value > 0 else { return .none }
//    return .some(14.0)
//}
//
//let x = logarithm(-2.0)
//
//switch x {
//case let .some(value):
//    print(value)
//case .none:
//    print("we got nuthin'")
//}


enum Maybe<T> {
    case some(T)
    case none
    
    var isNone: Bool {
        switch self {
        case .some: return false
        case .none: return true
        }
    }
}

func logarithm(_ value: Double) -> Double? {
    guard value > 0 else { return nil }
    return 14.0
}

let x2 = logarithm(2.0)
type(of: x2)
if let x2 = x2 {
    type(of: x2)
    print (x2 * 2.0)
}
type(of: x2)


let anArray: Array<Int> = [1,2,3]

var aMaybe: Maybe<Int> = .some(3)
var someOtherMaybe = aMaybe
var anotherMaybe: Maybe<String> = .some("aString")
anotherMaybe = .none

anotherMaybe.isNone
aMaybe.isNone

var optVan: Person? = Person(fullName: "Simmons, Van")

optVan?.age

optVan = nil
optVan?.age


var a6 = [[1,2,3],[4,5,6],[7,8,9]]

a6.map { _ in return 4 }

