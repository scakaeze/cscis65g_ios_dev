//: Playground - noun: a place where people can play

import UIKit

let array = [1,2,3].map {
    Double($0 * 2)
}

let nestedArray = [[1,2,3], [4,5,6]]
let unnested = nestedArray.flatMap { $0 }

unnested


array

var opt: Int? = 3

var otherThing = opt.map { Double($0 * 2) }
otherThing
type(of: otherThing)

//otherThing = opt.map {
//    let innerOpt: Int? = $0 * 2
//    return innerOpt
//}
//otherThing

otherThing = opt.flatMap {
    let innerOpt: Double? = Double($0 * 2)
    return innerOpt
}
otherThing
