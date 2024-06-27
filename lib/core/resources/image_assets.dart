enum ImageAssets {
  caution,
}

extension ImageAssetsExt on ImageAssets {
  String get path {
    switch (this) {
      case ImageAssets.caution:
      default:
        return "assets/images/caution.png";
    }
  }
}
