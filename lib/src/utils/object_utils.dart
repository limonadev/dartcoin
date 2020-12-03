class ObjectUtils {
  /// Implementation based on Effective Java Book, Item 11
  static int buildHashCode(List<Object> objects) {
    var result = 17;

    objects.forEach((object) {
      var objectHash = object is int ? object : object.hashCode;
      result = 31 * result + objectHash;
    });

    return result;
  }

  static String toHex(BigInt value) {
    return value.toRadixString(16).padLeft(64, '0');
  }
}
