import 'package:chat/chat.dart';
import 'package:flutter_chat_app/data/data_source/data_source_contract.dart';
import 'package:flutter_chat_app/models/chat.dart';
import 'package:flutter_chat_app/models/local_message.dart';
import 'package:flutter_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDataSource _dataSource;

  ChatsViewModel(this._dataSource) : super(_dataSource);

  Future<List<Chat>> getChats() async => await _dataSource.findAllChats();

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    await addMessage(localMessage);
  }
}
