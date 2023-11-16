import IGDB_SWIFT_API

// TODO: support sizes and types — må da exponere igdb_swift_api til app?
public func getImageUrl(_ imageId: String) -> String {
    let imageURL = imageBuilder(imageID: imageId, size: .COVER_BIG, imageType: .PNG)

    return imageURL
}
