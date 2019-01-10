//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let a = [1, 2, 3]
let b = ["a", "b", "c"]
let z = zip(a,b)

print(type(of:z))
print(z)

for t in z {
    print(type(of: t))
    print(t)
}

let i = 47
let array = [Int](repeatElement(i, count: 6))
let arrayOfArrays = [[Int]](repeatElement(array, count: 4))
arrayOfArrays

