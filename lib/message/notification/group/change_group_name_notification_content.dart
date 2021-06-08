import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_imclient/flutter_imclient.dart';
import 'package:flutter_imclient/message/message.dart';
import 'package:flutter_imclient/message/message_content.dart';
import 'package:flutter_imclient/message/notification/notification_message_content.dart';
import 'package:flutter_imclient/model/message_payload.dart';
import 'package:flutter_imclient/model/user_info.dart';

// ignore: non_constant_identifier_names
MessageContent ChangeGroupNameNotificationContentCreator() {
  return new ChangeGroupNameNotificationContent();
}

const changeGroupNameNotificationContentMeta = MessageContentMeta(
    MESSAGE_CONTENT_TYPE_CHANGE_GROUP_NAME,
    MessageFlag.PERSIST,
    ChangeGroupNameNotificationContentCreator);

class ChangeGroupNameNotificationContent extends NotificationMessageContent {
  String? groupId;
  String? operateUser;
  String? name;

  @override
  void decode(MessagePayload payload) {
    super.decode(payload);
    Map<dynamic, dynamic> map =
        json.decode(utf8.decode(payload.binaryContent!));
    operateUser = map['o'];
    groupId = map['g'];
    name = map['n'];
  }

  @override
  Future<String> digest(Message message) async {
    return formatNotification(message);
  }

  @override
  Future<MessagePayload> encode() async {
    MessagePayload payload = await (super.encode() as FutureOr<MessagePayload>);
    Map<String, dynamic> map = new Map();
    map['o'] = operateUser;
    map['g'] = groupId;
    map['n'] = name;
    payload.binaryContent = utf8.encode(json.encode(map)) as Uint8List?;
    return payload;
  }

  @override
  Future<String> formatNotification(Message message) async {
    if (operateUser == await FlutterImclient.currentUserId) {
      return '你 修改群名片为: $name';
    } else {
      UserInfo? userInfo =
          await FlutterImclient.getUserInfo(operateUser, groupId: groupId);
      if (userInfo != null) {
        if (userInfo.friendAlias != null && userInfo.friendAlias!.isNotEmpty) {
          return '${userInfo.friendAlias} 修改群名片为: $name';
        } else if (userInfo.groupAlias != null &&
            userInfo.groupAlias!.isNotEmpty) {
          return '${userInfo.groupAlias} 修改群名片为: $name';
        } else if (userInfo.displayName != null &&
            userInfo.displayName!.isNotEmpty) {
          return '${userInfo.displayName} 修改群名片为: $name';
        } else {
          return '$operateUser 修改群名片为: $name';
        }
      } else {
        return '$operateUser 修改群名片为: $name';
      }
    }
  }

  @override
  MessageContentMeta get meta => changeGroupNameNotificationContentMeta;
}
