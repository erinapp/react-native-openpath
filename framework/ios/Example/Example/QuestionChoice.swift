protocol IdentifiableByInt {
    var id: Int { get }
}

protocol QuestionChoice: CustomStringConvertible, IdentifiableByInt {}
