import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void updateLastAssistantMessage(String delta, {bool done = false}) {
    if (_messages.isEmpty) return;
    // 如果最后一条是 AI 在加载，则转为内容并附加；否则新建一条AI消息
    final last = _messages.last;
    if (!last.isUser) {
      final updated = last.copyWith(
        content: (last.content + delta),
        isLoading: !done && (last.isLoading || last.content.isEmpty),
      );
      _messages[_messages.length - 1] = updated;
    } else {
      _messages.add(ChatMessage(
        content: delta,
        isUser: false,
        timestamp: DateTime.now(),
        isLoading: !done,
      ));
    }
    notifyListeners();
  }

  void removeLastMessage() {
    if (_messages.isNotEmpty) {
      _messages.removeLast();
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
