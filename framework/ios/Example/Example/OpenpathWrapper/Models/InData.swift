/**
 * All Openpath SDK return values come wrapped in this object.
 */
struct InData<T>: Decodable where T: Decodable {
    let data: T
}
