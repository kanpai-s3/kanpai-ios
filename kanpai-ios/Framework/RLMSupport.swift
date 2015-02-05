////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Realm

extension RLMObject {
    // Swift query convenience functions
    public class func objectsWhere(predicateFormat: String, _ args: CVarArgType...) -> RLMResults {
        return objectsWithPredicate(NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }

    public class func objectsInRealm(realm: RLMRealm, _ predicateFormat: String, _ args: CVarArgType...) -> RLMResults {
        return objectsInRealm(realm, withPredicate:NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }
}

extension RLMArray: CollectionType {

    // Support Collection-type
    public var startIndex: UInt {
        return 0
    }
    
    public var endIndex: UInt {
        return self.count
    }
    
    public subscript (position: UInt) -> RLMObject {
        return (self.objectAtIndex(position) as? RLMObject)!
    }
    
    // Support Sequence-style enumeration
    public func generate() -> GeneratorOf<RLMObject> {
        var i: UInt  = 0

        return GeneratorOf<RLMObject> {
            if (i >= self.count) {
                return .None
            } else {
                return self[i++]
            }
        }
    }

    // Swift query convenience functions
    public func indexOfObjectWhere(predicateFormat: String, _ args: CVarArgType...) -> UInt {
        return indexOfObjectWithPredicate(NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }

    public func objectsWhere(predicateFormat: String, _ args: CVarArgType...) -> RLMResults {
        return objectsWithPredicate(NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }
    
    public func map<U>(callback: (RLMObject) -> U) -> [U] {
        var mapObjects = [U]()
        for obj in self {
            mapObjects.append(callback(obj))
        }
        return mapObjects
    }
}

extension RLMResults: SequenceType {
    // Support Sequence-style enumeration
    public func generate() -> GeneratorOf<RLMObject> {
        var i: UInt  = 0

        return GeneratorOf<RLMObject> {
            if (i >= self.count) {
                return .None
            } else {
                return self[i++] as? RLMObject
            }
        }
    }

    // Swift query convenience functions
    public func indexOfObjectWhere(predicateFormat: String, _ args: CVarArgType...) -> UInt {
        return indexOfObjectWithPredicate(NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }

    public func objectsWhere(predicateFormat: String, _ args: CVarArgType...) -> RLMResults {
        return objectsWithPredicate(NSPredicate(format: predicateFormat, arguments: getVaList(args)))
    }
}
