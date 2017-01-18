
enum State: Int { case s1, s2, s3, s4 }

enum Value: Int { case B, X }

enum MovementDirection { case L, R }

typealias ValueMovementVector = [Any]

struct ValueStatePair<ValueType: Hashable, StateType: Hashable>: Hashable {

    let pair: (ValueType, StateType)

    var hashValue: Int {
        get {
            let (a, b) = pair
            return a.hashValue &* 31 &+ b.hashValue
        }
    }
    
}

extension ValueStatePair: Equatable {}

func ==<ValueType: Hashable,
        StateType: Hashable>(lhs: ValueStatePair<ValueType, StateType>,
        rhs: ValueStatePair<ValueType, StateType>) -> Bool {
    return lhs.pair == rhs.pair
}

let X_B: Dictionary<ValueStatePair<Value, State>, ValueMovementVector> = [
    ValueStatePair(pair: (Value.B, State.s1)): [Value.X, MovementDirection.R, State.s2],
    ValueStatePair(pair: (Value.B, State.s2)): [Value.B, MovementDirection.L, State.s3],
    ValueStatePair(pair: (Value.X, State.s3)): [Value.B, MovementDirection.R, State.s4],
    ValueStatePair(pair: (Value.B, State.s4)): [Value.B, MovementDirection.L, State.s1]
]

func simulate(instructions: Dictionary<ValueStatePair<Value, State>, ValueMovementVector>) {

    var tape: [Value] = [.B, .B]
    var head = 0
    var state = State.s1

    (0...8).forEach { _ in
        print("\(state) : \(tape)")
        if head == 0 {
            print("\t\t^\n")
        }
        else {
            print("\t\t\t\t^\n")
        }

        let key = ValueStatePair(pair: (tape[head], state))
        let newState = instructions[key]![2] as! State
        let newValue = instructions[key]![0] as! Value
        let headDirection = instructions[key]![1] as! MovementDirection

        state = newState
        tape [head] = newValue

        if headDirection == .R {
            head = head + 1
        } else {
            head = head - 1
        }
    }


}

simulate(instructions: X_B)




