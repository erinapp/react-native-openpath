struct GetErrorsResponse: Decodable {
    let errors: [OpenpathErrorMessageAndCode]
}
