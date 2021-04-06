class ArticleCommentModel{
  String id;
  String articleId;
  String commenterName;
  String commenterPhoto;
  String comment;
  String commentDate;
  String timeStamp;

  ArticleCommentModel({this.id, this.commenterName, this.commenterPhoto,
      this.comment, this.commentDate, this.timeStamp,this.articleId});
}