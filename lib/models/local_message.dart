import 'package:chat/chat.dart';

class LocalMessage {
  String chatId;
  Message message;
  ReceiptStatus receiptStatus;

  String get id => _id;
  late String _id;

  LocalMessage(this.chatId, this.message, this.receiptStatus);

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message.id,
        ...message.toJson(),
        'receipt': receiptStatus.value()
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
        from: json['from'],
        to: json['to'],
        timestamp: json['timestamp'],
        contents: json['contents']);
    final localMessage =
        LocalMessage(json['chat_id'], message, json['receipt_status']);
    localMessage._id = json['id'];
    return localMessage;
  }
}
