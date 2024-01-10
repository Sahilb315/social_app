class CommentModel {
  String? commentedBy;
  String? commentedEmail;
  String? content;
  String? timestamp;

  CommentModel({
    this.commentedBy,
    this.commentedEmail,
    this.content,
    this.timestamp,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    commentedBy = json['commentedBy'];
    commentedEmail = json['commentedEmail'];
    content = json['content'];
    timestamp = json['timestamp'];
  }
}
