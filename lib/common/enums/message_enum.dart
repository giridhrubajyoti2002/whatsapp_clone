enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif'),
  music('music');

  final String type;
  const MessageEnum(this.type);
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'video':
        return MessageEnum.video;
      case 'gif':
        return MessageEnum.gif;
      case 'image':
        return MessageEnum.image;
      case 'music':
        return MessageEnum.music;
      default:
        return MessageEnum.text;
    }
  }
}
