part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}
class ChatSuccessState extends ChatState {
  List<Message>messages;
  ChatSuccessState({required this.messages});
}
