//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"
var str2 = "Some other string"

str = "new string"
str2 = "another new string"

type(of:str)

var aNum: Double = 13
let anotherNum = 47.48

type(of: aNum)
type(of: anotherNum)

let aBool = true

let aComplicatedString = "Check this out: \(aNum)"
print(aComplicatedString)

var anArray = ["some string","some other string", "blah", "blah"]
anArray += ["this string"]
print(anArray)

type(of: anArray)

var diffArray: Array<Any> = [13, 47.4, "A string"]
type(of: diffArray)

var diffArray2: [Any] = [13, 47.4, "A string"]

var aDict = ["someKey": aNum, "anotherKey": 49.4]
type(of: aDict)

aDict["someKey"]
aDict["thirdKey"] = 94.2
aDict["thirdKey"]
aDict

for (key,value) in aDict {
    print("Key is \(key), value is \(value)")
}

var aTuple = (number: aNum, string: str)
type(of: aTuple)

aTuple.0 = 38.1
aTuple.string = "this string"

func doubler(number: Int) -> Int {
    return number * 2
}

doubler(number: 14)

func doubler(_ number: Int) -> Int {
    return number * 3
}

doubler(14)

func doubler(toDouble number: Int) -> Int {
    return number * 2
}

doubler(toDouble: 14)

type(of: doubler(toDouble:))

func doublerFactory() -> (Int) -> Int {
    func theFunc(_ arg: Int) -> Int {
        return arg * 2
    }
    return theFunc
}

let doublerFunc = doublerFactory()

type(of: doublerFunc)
doublerFunc(14)

func weird(doubler: (Int) -> Int) -> Int {
    type(of: doubler)
    return doubler(16)
}

let doubleClosure = { (arg: Int) -> Int in
    return arg * 2
}

weird(doubler: doublerFunc)

weird(doubler: doubleClosure)

weird(doubler: { (arg:Int) -> Int in
    return arg * 2
})

weird(doubler: {
    return $0 * 2
})

weird(doubler: { $0 * 4 })

weird { $0 * 4 }

let newArray = [1, 2, 3, 4]

let doubledArray = newArray.map { $0 * 2}
doubledArray

var d: [Int] = []
for val in newArray {
    d.append(val * 2)
}
d

let printedArray = newArray.map { "\($0)" }

let doubledPrintedArray = newArray
    .map { $0 * 2 }
    .map { "\($0)" }

print(doubledPrintedArray)

let reduced = newArray.reduce(0) { $0 + $1 }
reduced

var i = 0
for j in newArray {
    i = i + j
}
i


let reducedString = newArray.reduce("") { $0 + "\($1)" }
reducedString

var someArray = [Int]()
newArray.forEach { someArray.append($0 * 2) }
someArray

(0 ..< 4).forEach { print ($0) }
