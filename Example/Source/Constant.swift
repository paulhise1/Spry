import Foundation

private func fatalError(title: String, entries: [String]) -> Never {
    let entriesString = entries.map { "\n  " + $0 }.joined() + "\n"
    fatalError(title + entriesString)
}

internal enum Constant {
    enum FatalError {
        static func wrongTypesBeingCompared(_ actual: SpryEquatable?, _ me: SpryEquatable) -> Never {
            let title = "Wrong types being equated"
            let entries = [
                "<\(type(of: actual))> could NOT be cast as <\(type(of: me))>"
            ]

            fatalError(title: title, entries: entries)
        }

        static func wrongNumberOfArgsBeingCompared(specifiedArguments: [SpryEquatable?], actualArguments: [Any?]) -> Never {
            let title = "Wrong number of arguments to compare"
            let entries = [
                "Specified <\(specifiedArguments.count)>, received <\(actualArguments.count)>",
                "Specified arguments <\(descriptionOfArguments(specifiedArguments))>",
                "Actual arguments <\(descriptionOfArguments(actualArguments))>"
            ]

            fatalError(title: title, entries: entries)
        }

        static func doesNotConformToEquatable(_ value: SpryEquatable) -> Never {
            let title = "Improper SpryEquatable"
            let entries = [
                "<\(type(of: value))> must either conform to Equatable or be changed to an AnyObject"
            ]

            fatalError(title: title, entries: entries)
        }

        static func doesNotConformToSpryEquatable(_ value: Any) -> Never {
            let title = "SpryEquatable required"
            let entries = [
                "<\(type(of: value))> must conform to SpryEquatable"
            ]

            fatalError(title: title, entries: entries)
        }

        static func shouldNotConformToOptionalType(_ value: Any) -> Never {
            let title = "Not allowed to conform to 'OptionalType'"
            let entries = [
                "<\(type(of: value))> should NOT conform to OptionalType. This is reserved for Optional<Wrapped>"
            ]

            fatalError(title: title, entries: entries)
        }

        static func argumentCaptorCouldNotReturnSpecifiedType<T>(value: Any?, type: T.Type) -> Never {
            let title = "Argument Capture: wrong argument type"
            let entries = [
                "Captured argument <\(value as Any)>",
                "Specified type <\(T.self)>"
            ]

            fatalError(title: title, entries: entries)
        }

        static func capturedArgumentsOutOfBounds(index: Int, capturedArguments: [Any?]) -> Never {
            let title = "Argument Capture: index out of bounds"
            let entries = [
                "Index <\(index)> is out of bounds for captured arguments",
                "Current captured arguments <\(descriptionOfArguments(capturedArguments))>"
            ]

            fatalError(title: title, entries: entries)
        }

        static func noReturnValueFoundForInstanceFunction<S: Stubbable, R>(stubbable: S, function: S.Function, arguments: [Any?], returnType: R.Type) -> Never {
            noReturnValueFoundForFunction(stubbableType: S.self, functionName: function.rawValue, arguments: arguments, returnType: R.self, stubsDictionary: stubbable._stubsDictionary)
        }

        static func noReturnValueFoundForClassFunction<S: Stubbable, R>(stubbableType _: S.Type, function: S.ClassFunction, arguments: [Any?], returnType: R.Type) -> Never {
            noReturnValueFoundForFunction(stubbableType: S.self, functionName: function.rawValue, arguments: arguments, returnType: R.self, stubsDictionary: S._stubsDictionary)
        }

        static func noReturnValueSourceFound(functionName: String) -> Never {
            let title = "Incomplete Stub"
            let entries = [
                "Must add '.andReturn()', '.andDo()', or '.andThrow()' when stubbing a function"
            ]

            fatalError(title: title, entries: entries)
        }

        static func andThrowOnNonThrowingInstanceFunction<S: Stubbable>(stubbable: S, function: S.Function) -> Never {
            andThrowOnNonThrowingFunction(type: S.self, functionName: function.rawValue)
        }

        static func andThrowOnNonThrowingClassFunction<S: Stubbable>(stubbable: S.Type, function: S.ClassFunction) -> Never {
            andThrowOnNonThrowingFunction(type: S.self, functionName: function.rawValue)
        }

        // MARK: - Private

        private static func noReturnValueFoundForFunction<S, R>(stubbableType: S.Type, functionName: String, arguments: [Any?], returnType: R.Type, stubsDictionary: StubsDictionary) -> Never {
            let title = "No return value found"
            let entries = [
                "For <\(S.self).\(functionName)> with received arguments <\(descriptionOfArguments(arguments))> returning a <\(R.self)>",
                "Current stubs: <\(stubsDictionary.description)>"
            ]

            fatalError(title: title, entries: entries)
        }

        private static func andThrowOnNonThrowingFunction<T>(type: T.Type, functionName: String) -> Never {
            let title = "Used '.andThrow()' on non-throwing function"
            let entries = [
                "Tried to throw from <\(T.self).\(functionName)>",
                "If this function can throw, use 'spryifyThrows' or 'stubbedValueThrows' as the return value"
            ]

            fatalError(title: title, entries: entries)
        }

        private static func descriptionOfArguments(_ arguments: [Any?]) -> String {
            return arguments
                .map{"<\($0 as Any)>"}
                .joined(separator: ", ")
        }
    }
}