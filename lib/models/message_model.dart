import 'dart:convert';

class MessageModel {
  final String message;
  final String senderEmail;
  final String receiverEmail;
  final String messageSent;
  
  MessageModel({
    required this.message,
    required this.senderEmail,
    required this.receiverEmail,
    required this.messageSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'messageSent': messageSent,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      senderEmail: map['senderEmail'] as String,
      receiverEmail: map['receiverEmail'] as String,
      messageSent: map['messageSent'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(message: $message, senderEmail: $senderEmail, receiverEmail: $receiverEmail, messageSent: $messageSent)';
  }

  MessageModel copyWith({
    String? message,
    String? senderEmail,
    String? receiverEmail,
    String? messageSent,
  }) {
    return MessageModel(
      message: message ?? this.message,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverEmail: receiverEmail ?? this.receiverEmail,
      messageSent: messageSent ?? this.messageSent,
    );
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.senderEmail == senderEmail &&
        other.receiverEmail == receiverEmail &&
        other.messageSent == messageSent;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        senderEmail.hashCode ^
        receiverEmail.hashCode ^
        messageSent.hashCode;
  }
}
