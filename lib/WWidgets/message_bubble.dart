import 'package:chat_system/Models/Chat_message.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble(
      {required this.width,
      required this.isOwnMessage,
      required this.height,
      required this.message});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [Color.fromRGBO(0, 136, 249, 1.0), Color.fromRGBO(0, 82, 218, 1.0)]
        : [Color.fromRGBO(51, 49, 68, 1.0), Color.fromRGBO(51, 49, 68, 1.0)];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: [0.30, 0.70],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(color: Colors.white),
          ),
          
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const ImageMessageBubble(
      {required this.width,
      required this.height,
      required this.isOwnMessage,
      required this.message});

  @override
  Widget build(BuildContext context) {
    List<Color> _colorScheme = isOwnMessage
        ? [Color.fromRGBO(0, 136, 249, 1.0), Color.fromRGBO(0, 82, 218, 1.0)]
        : [Color.fromRGBO(51, 49, 68, 1.0), Color.fromRGBO(51, 49, 68, 1.0)];
    DecorationImage _image =
        DecorationImage(image: NetworkImage(message.content), fit: BoxFit.fill);
    print(message.type);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: [0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width * 0.75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), image: _image),
          ),
          Text(
            timeago.format(message.sentTime),
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}
