class SingleVideoModel {
  final int id;
  final List dataOfVideo;
  final List resolutions;
  final String name, duration, videoLink, desc, imgLink, typeOfVideo;
  SingleVideoModel(this.id, this.dataOfVideo, this.resolutions, this.name,
      this.videoLink, this.duration, this.desc, this.imgLink, this.typeOfVideo);
}
