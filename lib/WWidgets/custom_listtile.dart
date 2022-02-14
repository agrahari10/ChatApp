import 'package:chat_system/Models/Chat_message.dart';
import 'package:chat_system/Models/chat_user.dart';
import 'package:chat_system/WWidgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Rounded_image.dart';

class CustomListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  CustomListViewTile(
      {required this.height,
      required this.imagePath,
      required this.title,
      required this.isActive,
      required this.isSelected,
      required this.onTap,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white54,
            )
          : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.30,
      leading: Container(
        width: 40.0,
        height: 40.0,
        child: RoundedImageNetworkWithStatusIndicator(
          key: UniqueKey(),
          size: height / 2,
          imagePath: imagePath,
          isActive: isActive,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
      ),
    );
  }
}

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  CustomListViewTileWithActivity(
      {required this.height,
      required this.imagePath,
      required this.title,
      required this.isActive,
      required this.isActivity,
      required this.onTap,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => onTap(),
        minVerticalPadding: height * 0.20,
        leading: Container(
          width: 60,
          child: RoundedImageNetworkWithStatusIndicator(
            imagePath: imagePath,
            isActive: isActive,
            key: UniqueKey(),
            size: height / 2,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: isActivity
            ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: Colors.white54,
                    size: height * 0.10,
                  )
                ],
              )
            : Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ));
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  const CustomChatListViewTile(
      {required this.deviceHeight,
      required this.isOwnMessage,
      required this.message,
      required this.sender,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImage(
                  imagePath: sender.imageURL,
                  key: UniqueKey(),
                  size: width * 0.004,
                )
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubble(
                  width: width * 0.8,
                  isOwnMessage: isOwnMessage,
                  height: deviceHeight * 0.06,
                  message: message)
              : ImageMessageBubble(
                  width: width * 0.8,
                  height: deviceHeight * 0.25,
                  isOwnMessage: isOwnMessage,
                  message: message,
                )
        ],
      ),
    );
  }
}
