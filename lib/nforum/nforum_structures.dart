import 'package:json_annotation/json_annotation.dart';

part 'nforum_structures.g.dart';

@JsonSerializable()
class WelcomeInfo {
  WelcomeInfo(this.ver, this.url, this.sign);

  int ver;
  String url;
  String sign;

  factory WelcomeInfo.fromJson(Map<String, dynamic> json) => _$WelcomeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WelcomeInfoToJson(this);
}

abstract class OAuthInfo {}

@JsonSerializable()
class OAuthAccessInfo extends OAuthInfo {
  OAuthAccessInfo(this.accessToken, this.expiresIn);

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'expires_in')
  int expiresIn;

  factory OAuthAccessInfo.fromJson(Map<String, dynamic> json) => _$OAuthAccessInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthAccessInfoToJson(this);
}

@JsonSerializable()
class OAuthErrorInfo extends OAuthInfo {
  OAuthErrorInfo(this.code, this.msg);

  int code;
  String msg;

  factory OAuthErrorInfo.fromJson(Map<String, dynamic> json) => _$OAuthErrorInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OAuthErrorInfoToJson(this);
}

@JsonSerializable()
class StatusModel {
  bool status;

  StatusModel(this.status);

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusModelToJson(this);
}

@JsonSerializable()
class UserModel extends PageableBaseModel {
  UserModel(this.id, this.userName, this.faceUrl);

  String id;
  @JsonKey(name: 'user_name')
  String userName;
  @JsonKey(name: 'face_url')
  String faceUrl;
  @JsonKey(name: 'face_width')
  int faceWidth;
  @JsonKey(name: 'face_height')
  int faceHeight;
  @JsonKey(name: 'gender')
  String gender;
  @JsonKey(name: 'astro')
  String astro;
  @JsonKey(name: 'life')
  int life;
  @JsonKey(name: 'qq')
  String qq;
  @JsonKey(name: 'msn')
  String msn;
  @JsonKey(name: 'home_page')
  String homePage;
  @JsonKey(name: 'level')
  String level;
  @JsonKey(name: 'is_online')
  bool isOnline;
  @JsonKey(name: 'post_count')
  int postCount;
  @JsonKey(name: 'last_login_time')
  int lastLoginTime;
  @JsonKey(name: 'last_login_ip')
  String lastLoginIp;
  @JsonKey(name: 'is_hide')
  bool isHide;
  @JsonKey(name: 'is_register')
  bool isRegister;
  @JsonKey(name: 'score')
  int score;
  @JsonKey(name: 'follow_num')
  int followNum;
  @JsonKey(name: 'fans_num')
  int fansNum;
  @JsonKey(name: 'is_follow')
  bool isFollow;
  @JsonKey(name: 'is_fan')
  bool isFan;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String get objCode => "user/" + id.toString();
}

@JsonSerializable()
class UploadedModel {
  UploadedModel(this.name, this.url, this.size, this.thumbnailSmall, this.thumbnailMiddle, this.used);

  String name;
  String url;
  String size;
  @JsonKey(name: 'thumbnail_small')
  String thumbnailSmall;
  @JsonKey(name: 'thumbnail_middle')
  String thumbnailMiddle;
  bool used = false;

  factory UploadedModel.fromJson(Map<String, dynamic> json) => _$UploadedModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedModelToJson(this);
}

@JsonSerializable()
class AttachmentModel {
  AttachmentModel(
    this.file,
    this.remainSpace,
    this.remainCount,
  );

  List<UploadedModel> file;
  @JsonKey(name: 'remain_space')
  String remainSpace;
  @JsonKey(name: 'remain_count')
  int remainCount;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) => _$AttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentModelToJson(this);
}

@JsonSerializable()
class ToptenModel {
  ToptenModel({
    this.name,
    this.title,
    this.time,
    this.article,
  });

  String name;
  String title;
  int time;
  List<FrontArticleModel> article;

  factory ToptenModel.fromJson(Map<String, dynamic> json) => _$ToptenModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToptenModelToJson(this);
}

@JsonSerializable()
class FrontArticleModel extends ArticleBaseModel {
  FrontArticleModel({
    this.id,
    this.groupId,
    this.replyId,
    this.flag,
    this.position,
    this.isTop,
    this.isSubject,
    this.hasAttachment,
    this.isAdmin,
    this.title,
    this.user,
    this.postTime,
    this.boardName,
    this.boardDescription,
    this.content,
    this.attachment,
    this.replyCount,
    this.lastReplyUserId,
    this.lastReplyTime,
    this.idCount,
  }) : super(
          groupId: groupId,
          title: title,
          user: user,
          postTime: postTime,
          boardName: boardName,
        );

  @JsonKey(name: 'group_id')
  var groupId;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  var postTime;
  @JsonKey(name: 'board_name')
  var boardName;
  int id;
  @JsonKey(name: 'reply_id')
  int replyId;
  @JsonKey(name: 'flag')
  String flag;
  int position;
  @JsonKey(name: 'is_top')
  bool isTop;
  @JsonKey(name: 'is_subject')
  bool isSubject;
  @JsonKey(name: 'has_attachment')
  bool hasAttachment;
  @JsonKey(name: 'is_admin')
  bool isAdmin;
  @JsonKey(name: 'board_description')
  String boardDescription;
  String content;
  AttachmentModel attachment;
  @JsonKey(name: 'reply_count')
  int replyCount;
  @JsonKey(name: 'last_reply_user_id')
  String lastReplyUserId;
  @JsonKey(name: 'last_reply_time')
  int lastReplyTime;
  @JsonKey(name: 'id_count')
  String idCount;

  factory FrontArticleModel.fromJson(Map<String, dynamic> json) => _$FrontArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$FrontArticleModelToJson(this);
}

@JsonSerializable()
class TimelineModel extends ArticleListBaseModel<FrontArticleModel> {
  TimelineModel({
    this.article,
    this.pagination,
  }) : super(
          article: article,
          pagination: pagination,
        );

  List<FrontArticleModel> article;

  PaginationModel pagination;

  factory TimelineModel.fromJson(Map<String, dynamic> json) => _$TimelineModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);
}

@JsonSerializable()
class ArticleBaseModel extends PageableBaseModel {
  ArticleBaseModel({
    this.groupId,
    this.title,
    this.user,
    this.postTime,
    this.boardName,
  }) : super();

  @JsonKey(name: 'group_id')
  var groupId;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  var postTime;
  @JsonKey(name: 'board_name')
  var boardName;

  @override
  String get objCode => "article/" + boardName.toString() + "/" + groupId.toString();

  factory ArticleBaseModel.fromJson(Map<String, dynamic> json) => _$ArticleBaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleBaseModelToJson(this);
}

abstract class PageableBaseModel {
  String get objCode;
}

abstract class PageableListBaseModel<T extends PageableBaseModel> {
  PageableListBaseModel({
    this.pagination,
    this.article,
  });

  PaginationModel pagination;
  List<T> article;
}

@JsonSerializable()
class UserListModel extends PageableListBaseModel<UserModel> {
  UserListModel({
    this.pagination,
    this.article,
  }) : super(pagination: pagination, article: article);

  PaginationModel pagination;
  @JsonKey(name: 'user')
  List<UserModel> article;

  factory UserListModel.fromJson(Map<String, dynamic> json) => _$UserListModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserListModelToJson(this);
}

abstract class ArticleListBaseModel<T extends ArticleBaseModel> extends PageableListBaseModel<T> {
  ArticleListBaseModel({
    this.pagination,
    this.article,
  }) : super(pagination: pagination, article: article);

  PaginationModel pagination;
  List<T> article;
}

@JsonSerializable()
class ThreadArticleModel extends ArticleBaseModel {
  ThreadArticleModel({
    this.id,
    this.groupId,
    this.replyId,
    this.flag,
    this.position,
    this.isTop,
    this.isSubject,
    this.hasAttachment,
    this.isAdmin,
    this.title,
    this.user,
    this.postTime,
    this.boardName,
    this.boardDescription,
    this.content,
    this.attachment,
    this.likeSum,
    this.isLiked,
    this.votedownSum,
    this.isVotedown,
    this.hiddenByVotedown,
  }) : super(
          groupId: groupId,
          title: title,
          user: user,
          postTime: postTime,
          boardName: boardName,
        );

  @JsonKey(name: 'group_id')
  var groupId;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  var postTime;
  @JsonKey(name: 'board_name')
  var boardName;
  int id;
  @JsonKey(name: 'reply_id')
  int replyId;
  @JsonKey(name: 'flag')
  String flag;
  int position;
  @JsonKey(name: 'is_top')
  bool isTop;
  @JsonKey(name: 'is_subject')
  bool isSubject;
  @JsonKey(name: 'has_attachment')
  bool hasAttachment;
  @JsonKey(name: 'is_admin')
  bool isAdmin;
  @JsonKey(name: 'board_description')
  String boardDescription;
  String content;
  AttachmentModel attachment;
  @JsonKey(name: 'like_sum')
  String likeSum;
  @JsonKey(name: 'is_liked')
  bool isLiked;
  @JsonKey(name: 'votedown_sum')
  String votedownSum;
  @JsonKey(name: 'is_votedown')
  bool isVotedown;
  @JsonKey(name: 'hidden_by_votedown')
  bool hiddenByVotedown;

  @override
  String get objCode => "threadarticle/" + boardName.toString() + "/" + id.toString();

  factory ThreadArticleModel.fromJson(Map<String, dynamic> json) => _$ThreadArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadArticleModelToJson(this);
}

@JsonSerializable()
class LikeArticleModel extends ArticleBaseModel {
  LikeArticleModel({
    this.id,
    this.groupId,
    this.replyId,
    this.flag,
    this.position,
    this.isTop,
    this.isSubject,
    this.hasAttachment,
    this.isAdmin,
    this.title,
    this.user,
    this.postTime,
    this.boardName,
    this.boardDescription,
    this.content,
    this.attachment,
    this.likeSum,
    this.isLiked,
  }) : super(
          groupId: groupId,
          title: title,
          user: user,
          postTime: postTime,
          boardName: boardName,
        );

  @JsonKey(name: 'group_id')
  var groupId;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  var postTime;
  @JsonKey(name: 'board_name')
  var boardName;
  int id;
  @JsonKey(name: 'reply_id')
  int replyId;
  @JsonKey(name: 'flag')
  String flag;
  int position;
  @JsonKey(name: 'is_top')
  bool isTop;
  @JsonKey(name: 'is_subject')
  bool isSubject;
  @JsonKey(name: 'has_attachment')
  bool hasAttachment;
  @JsonKey(name: 'is_admin')
  bool isAdmin;
  @JsonKey(name: 'board_description')
  String boardDescription;
  String content;
  AttachmentModel attachment;
  @JsonKey(name: 'like_sum')
  String likeSum;
  @JsonKey(name: 'is_liked')
  bool isLiked;
  bool isVotedown = false;

  @override
  String get objCode => "likearticle/" + boardName.toString() + "/" + id.toString();

  factory LikeArticleModel.fromJson(Map<String, dynamic> json) => _$LikeArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$LikeArticleModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  PaginationModel(this.pageAllCount, this.pageCurrentCount, this.itemPageCount, this.itemAllCount);

  @JsonKey(name: 'page_all_count')
  int pageAllCount;
  @JsonKey(name: 'page_current_count')
  int pageCurrentCount;
  @JsonKey(name: 'item_page_count')
  int itemPageCount;
  @JsonKey(name: 'item_all_count')
  int itemAllCount;

  factory PaginationModel.fromJson(Map<String, dynamic> json) => _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}

@JsonSerializable()
class ThreadModel extends ArticleListBaseModel<ThreadArticleModel> {
  ThreadModel({
    this.id,
    this.groupId,
    this.replyId,
    this.flag,
    this.position,
    this.isTop,
    this.isSubject,
    this.hasAttachment,
    this.isAdmin,
    this.title,
    this.user,
    this.postTime,
    this.boardName,
    this.boardDescription,
    this.likeSum,
    this.isLiked,
    this.votedownSum,
    this.isVotedown,
    this.hiddenByVotedown,
    this.collect,
    this.replyCount,
    this.lastReplyUserId,
    this.lastReplyTime,
    this.likeArticles,
    this.pagination,
    this.article,
  }) : super(
          pagination: pagination,
          article: article,
        );

  int id;
  @JsonKey(name: 'group_id')
  int groupId;
  @JsonKey(name: 'reply_id')
  int replyId;
  @JsonKey(name: 'flag')
  String flag;
  int position;
  @JsonKey(name: 'is_top')
  bool isTop;
  @JsonKey(name: 'is_subject')
  bool isSubject;
  @JsonKey(name: 'has_attachment')
  bool hasAttachment;
  @JsonKey(name: 'is_admin')
  bool isAdmin;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  int postTime;
  @JsonKey(name: 'board_name')
  String boardName;
  @JsonKey(name: 'board_description')
  String boardDescription;
  @JsonKey(name: 'like_sum')
  String likeSum;
  @JsonKey(name: 'is_liked')
  bool isLiked;
  @JsonKey(name: 'votedown_sum')
  String votedownSum;
  @JsonKey(name: 'is_votedown')
  bool isVotedown;
  @JsonKey(name: 'hidden_by_votedown')
  bool hiddenByVotedown;
  @JsonKey(name: 'collect')
  bool collect;
  @JsonKey(name: 'reply_count')
  int replyCount;
  @JsonKey(name: 'last_reply_user_id')
  String lastReplyUserId;
  @JsonKey(name: 'last_reply_time')
  int lastReplyTime;
  @JsonKey(name: 'like_articles')
  List<LikeArticleModel> likeArticles;
  PaginationModel pagination;
  List<ThreadArticleModel> article;

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);
}

@JsonSerializable()
class BetCategoriesModel {
  List<BetCategoryModel> category;
  BetCategoriesModel(
    this.category,
  );

  factory BetCategoriesModel.fromJson(Map<String, dynamic> json) => _$BetCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetCategoriesModelToJson(this);
}

@JsonSerializable()
class BetCategoryModel {
  int cid;
  String name;
  bool show;

  BetCategoryModel(
    this.cid,
    this.name,
    this.show,
  );

  factory BetCategoryModel.fromJson(Map<String, dynamic> json) => _$BetCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetCategoryModelToJson(this);
}

enum BetRankType {
  rank_score,
  rank_win,
  rank_rate,
  rank_total,
}

enum BetAttrType {
  attr_new,
  attr_hist,
  attr_join,
}

enum VoteAttrType {
  attr_new,
  attr_hot,
  attr_all,
  attr_me,
  attr_join,
  attr_list,
}

@JsonSerializable()
class BetItemModel {
  String biid;
  String label;
  @JsonKey(name: 'num')
  String number;
  String score;
  String percent;

  BetItemModel(
    this.biid,
    this.label,
    this.number,
    this.score,
    this.percent,
  );

  factory BetItemModel.fromJson(Map<String, dynamic> json) => _$BetItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetItemModelToJson(this);
}

@JsonSerializable()
class MyBetItemModel {
  String uid;
  String biid;
  String score;
  int bonus;
  String result;

  MyBetItemModel(
    this.uid,
    this.biid,
    this.score,
    this.bonus,
    this.result,
  );

  factory MyBetItemModel.fromJson(Map<String, dynamic> json) => _$MyBetItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyBetItemModelToJson(this);
}

@JsonSerializable()
class BetModel extends PageableBaseModel {
  String bid;
  String cate;
  String title;
  String desc;
  String start;
  String end;
  @JsonKey(name: 'num')
  String number;
  String limit;
  int discount;
  String score;
  String aid;
  String result;
  bool isEnd;
  bool isDel;
  bool hasResult;
  List<BetItemModel> bitems;
  MyBetItemModel mybet;

  BetModel(
    this.bid,
    this.cate,
    this.title,
    this.desc,
    this.start,
    this.end,
    this.number,
    this.limit,
    this.discount,
    this.score,
    this.aid,
    this.result,
    this.isEnd,
    this.isDel,
    this.hasResult,
    this.bitems,
    this.mybet,
  ) : super();

  @override
  String get objCode => "bet/" + bid.toString();

  factory BetModel.fromJson(Map<String, dynamic> json) => _$BetModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetModelToJson(this);
}

@JsonSerializable()
class BetListModel extends PageableListBaseModel<BetModel> {
  PaginationModel pagination;
  @JsonKey(name: 'bets')
  List<BetModel> article;
  String title;

  BetListModel(
    this.pagination,
    this.article,
    this.title,
  ) : super(pagination: pagination, article: article);

  factory BetListModel.fromJson(Map<String, dynamic> json) => _$BetListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetListModelToJson(this);
}

@JsonSerializable()
class BetRankItemModel {
  String uid;
  String total;
  String win;
  String rate;
  String score;

  BetRankItemModel(
    this.uid,
    this.total,
    this.win,
    this.rate,
    this.score,
  );

  factory BetRankItemModel.fromJson(Map<String, dynamic> json) => _$BetRankItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetRankItemModelToJson(this);
}

@JsonSerializable()
class BetRankListModel {
  Map<String, String> types;
  List<BetRankItemModel> rank;

  BetRankListModel(
    this.types,
    this.rank,
  );

  factory BetRankListModel.fromJson(Map<String, dynamic> json) => _$BetRankListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BetRankListModelToJson(this);
}

@JsonSerializable()
class VoteItemModel {
  String viid;
  String label;
  @JsonKey(name: 'num')
  String number;

  VoteItemModel(
    this.viid,
    this.label,
    this.number,
  );

  factory VoteItemModel.fromJson(Map<String, dynamic> json) => _$VoteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoteItemModelToJson(this);
}

@JsonSerializable()
class VoteStatusModel {
  String time;
  List<String> viid;

  VoteStatusModel(
    this.time,
    viid,
  ) {
    this.viid = viid?.cast<String>();
  }

  factory VoteStatusModel.fromJson(Map<String, dynamic> json) => _$VoteStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoteStatusModelToJson(this);
}

@JsonSerializable()
class VoteModel extends PageableBaseModel {
  String vid;
  String title;
  String start;
  String end;
  @JsonKey(name: 'user_count')
  String userCount;
  @JsonKey(name: 'vote_count')
  int voteCount;
  String type;
  String limit;
  String aid;
  @JsonKey(name: 'is_end')
  bool isEnd;
  @JsonKey(name: 'is_deleted')
  bool isDel;
  @JsonKey(name: 'is_result_voted')
  bool isResultVoted;
  UserModel user;
  @JsonKey(name: 'vote_status')
  VoteStatusModel voteStatus;
  List<VoteItemModel> options;

  VoteModel(
    this.vid,
    this.title,
    this.start,
    this.end,
    this.userCount,
    this.voteCount,
    this.type,
    this.limit,
    this.aid,
    this.isEnd,
    this.isDel,
    this.isResultVoted,
    this.user,
    dynamic voteStatus,
    this.options,
  ) : super() {
    if (voteStatus is List) {
      this.voteStatus = null;
    } else {
      this.voteStatus = VoteStatusModel.fromJson(voteStatus);
    }
  }

  @override
  String get objCode => "vote/" + vid.toString();

  factory VoteModel.fromJson(Map<String, dynamic> json) => _$VoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoteModelToJson(this);
}

@JsonSerializable()
class VoteListModel extends PageableListBaseModel<VoteModel> {
  PaginationModel pagination;
  @JsonKey(name: 'votes')
  List<VoteModel> article;

  VoteListModel(
    this.pagination,
    this.article,
  ) : super(pagination: pagination, article: article);

  factory VoteListModel.fromJson(Map<String, dynamic> json) => _$VoteListModelFromJson(json);

  Map<String, dynamic> toJson() => _$VoteListModelToJson(this);
}

@JsonSerializable()
class BannerElementModel {
  @JsonKey(name: 'image_url')
  String imageUrl;
  String intro;
  String url;

  BannerElementModel(
    this.imageUrl,
    this.intro,
    this.url,
  );

  factory BannerElementModel.fromJson(Map<String, dynamic> json) => _$BannerElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerElementModelToJson(this);
}

@JsonSerializable()
class BannerModel {
  int count;
  List<BannerElementModel> banners;

  BannerModel(
    this.count,
    this.banners,
  );

  factory BannerModel.fromJson(Map<String, dynamic> json) => _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

@JsonSerializable()
class SectionModel {
  String name;
  String description;
  @JsonKey(name: 'is_root')
  bool isRoot;
  String parent;
  @JsonKey(name: 'sub_section')
  List<String> subSection;
  List<BoardModel> board;

  SectionModel(
    this.name,
    this.description,
    this.isRoot,
    this.parent,
    subSection,
    this.board,
  ) {
    this.subSection = subSection?.cast<String>();
  }

  factory SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionModelToJson(this);
}

@JsonSerializable()
class SectionListModel {
  @JsonKey(name: 'section')
  List<SectionModel> sections;

  SectionListModel(
    this.sections,
  );

  factory SectionListModel.fromJson(Map<String, dynamic> json) => _$SectionListModelFromJson(json);

  Map<String, dynamic> toJson() => _$SectionListModelToJson(this);
}

@JsonSerializable()
class BoardModel extends ArticleListBaseModel<FrontArticleModel> {
  String name;
  String manager;
  String description;
  @JsonKey(name: 'class')
  String nameOfClass;
  String section;
  @JsonKey(name: 'is_favorite')
  bool isFavorite;
  @JsonKey(name: 'threads_today_count')
  int threadsTodayCount;
  @JsonKey(name: 'post_today_count')
  int postTodayCount;
  @JsonKey(name: 'post_threads_count')
  int postThreadsCount;
  @JsonKey(name: 'post_all_count')
  int postAllCount;
  @JsonKey(name: 'user_online_count')
  int userOnlineCount;
  @JsonKey(name: 'user_online_max_count')
  int userOnlineMaxCount;
  @JsonKey(name: 'user_online_max_time')
  int userOnlineMaxTime;
  @JsonKey(name: 'is_read_only')
  bool isReadOnly;
  @JsonKey(name: 'is_no_reply')
  bool isNoReply;
  @JsonKey(name: 'allow_attachment')
  bool allowAttachment;
  @JsonKey(name: 'allow_anonymous')
  bool allowAnonymous;
  @JsonKey(name: 'allow_outgo')
  bool allowOutgo;
  @JsonKey(name: 'allow_post')
  bool allowPost;
  @JsonKey(name: 'pagination')
  PaginationModel pagination;
  @JsonKey(name: 'article')
  List<FrontArticleModel> article;

  BoardModel({
    this.name,
    this.manager,
    this.description,
    this.nameOfClass,
    this.section,
    this.isFavorite,
    this.threadsTodayCount,
    this.postTodayCount,
    this.postThreadsCount,
    this.postAllCount,
    this.userOnlineCount,
    this.userOnlineMaxCount,
    this.userOnlineMaxTime,
    this.isReadOnly,
    this.isNoReply,
    this.allowAttachment,
    this.allowAnonymous,
    this.allowOutgo,
    this.allowPost,
    this.pagination,
    this.article,
  }) : super(
          pagination: pagination,
          article: article,
        );

  factory BoardModel.fromJson(Map<String, dynamic> json) => _$BoardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardModelToJson(this);
}

@JsonSerializable()
class FavBoardsModel {
  @JsonKey(name: 'sub_favorite')
  List<BoardModel> subFavorite;
  List<BoardModel> section;
  List<BoardModel> board;

  FavBoardsModel(
    this.subFavorite,
    this.section,
    this.board,
  );

  factory FavBoardsModel.fromJson(Map<String, dynamic> json) => _$FavBoardsModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavBoardsModelToJson(this);
}

@JsonSerializable()
class CollectionArticleModel extends ArticleBaseModel {
  var createdTime;
  String title;
  var postTime;
  @JsonKey(name: 'bname')
  var boardName;
  @JsonKey(name: 'num')
  var number;
  @JsonKey(name: 'gid')
  var groupId;
  UserModel user;

  CollectionArticleModel({
    this.createdTime,
    this.title,
    this.postTime,
    this.boardName,
    this.number,
    this.groupId,
    this.user,
  }) : super(
          groupId: groupId,
          title: title,
          postTime: postTime,
          user: user,
          boardName: boardName,
        );

  @override
  String get objCode => "collectionarticle/" + boardName.toString() + "/" + groupId.toString();

  factory CollectionArticleModel.fromJson(Map<String, dynamic> json) => _$CollectionArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionArticleModelToJson(this);
}

@JsonSerializable()
class CollectionModel extends ArticleListBaseModel<CollectionArticleModel> {
  List<CollectionArticleModel> article;
  @JsonKey(name: 'pagination')
  PaginationModel pagination;

  CollectionModel({
    this.article,
    this.pagination,
  }) : super(
          pagination: pagination,
          article: article,
        );

  factory CollectionModel.fromJson(Map<String, dynamic> json) => _$CollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionModelToJson(this);
}

@JsonSerializable()
class ReferModel extends ArticleBaseModel {
  int index;
  int id;
  @JsonKey(name: 'group_id')
  var groupId;
  @JsonKey(name: 'reply_id')
  int replyId;
  @JsonKey(name: 'board_name')
  var boardName;
  String title;
  int pos;
  UserModel user;
  int time;
  @JsonKey(name: 'is_read')
  bool isRead;

  ReferModel({
    this.index,
    this.id,
    this.groupId,
    this.replyId,
    this.boardName,
    this.title,
    this.pos,
    this.user,
    this.time,
    this.isRead,
  }) : super(
          title: title,
          user: user,
          postTime: time,
          groupId: groupId,
          boardName: boardName,
        );

  @override
  String get objCode => "refer/" + boardName.toString() + "/" + id.toString();

  factory ReferModel.fromJson(Map<String, dynamic> json) => _$ReferModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferModelToJson(this);
}

@JsonSerializable()
class ReferBoxModel extends ArticleListBaseModel<ReferModel> {
  String description;
  PaginationModel pagination;
  @JsonKey(name: 'article')
  List<ReferModel> article;

  ReferBoxModel({
    this.description,
    this.pagination,
    this.article,
  }) : super(
          pagination: pagination,
          article: article,
        );

  factory ReferBoxModel.fromJson(Map<String, dynamic> json) => _$ReferBoxModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReferBoxModelToJson(this);
}

@JsonSerializable()
class MailModel extends PageableBaseModel {
  int index;
  @JsonKey(name: 'is_m')
  bool isM;
  @JsonKey(name: 'is_read')
  bool isRead;
  @JsonKey(name: 'is_reply')
  bool isReply;
  @JsonKey(name: 'has_attachment')
  bool hasAttachment;
  String title;
  UserModel user;
  @JsonKey(name: 'post_time')
  int postTime;
  @JsonKey(name: 'box_name')
  String boxName;
  String content;
  AttachmentModel attachment;

  MailModel(
    this.index,
    this.isM,
    this.isRead,
    this.isReply,
    this.hasAttachment,
    this.title,
    this.user,
    this.postTime,
    this.boxName,
    this.content,
    this.attachment,
  ) : super();

  @override
  String get objCode => "mail/" + boxName.toString() + "/" + index.toString();

  factory MailModel.fromJson(Map<String, dynamic> json) => _$MailModelFromJson(json);

  Map<String, dynamic> toJson() => _$MailModelToJson(this);
}

@JsonSerializable()
class MailBoxModel extends PageableListBaseModel<MailModel> {
  String description;
  @JsonKey(name: 'new_num')
  int newNum;
  PaginationModel pagination;
  @JsonKey(name: 'mail')
  List<MailModel> article;

  MailBoxModel({this.description, this.newNum, this.pagination, this.article})
      : super(pagination: pagination, article: article);

  factory MailBoxModel.fromJson(Map<String, dynamic> json) => _$MailBoxModelFromJson(json);

  Map<String, dynamic> toJson() => _$MailBoxModelToJson(this);
}

@JsonSerializable()
class BoardSearchModel {
  List<String> section;
  List<BoardModel> board;

  BoardSearchModel(section, this.board) {
    this.section = section?.cast<String>();
  }

  factory BoardSearchModel.fromJson(Map<String, dynamic> json) => _$BoardSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardSearchModelToJson(this);

  FavBoardsModel getFavBoardList() {
    FavBoardsModel f = FavBoardsModel([], [], this.board);
    f.board.sort((a, b) => b.threadsTodayCount.compareTo(a.threadsTodayCount));
    return f;
  }
}

@JsonSerializable()
class ThreadSearchModel {
  @JsonKey(name: 'pagination')
  PaginationModel pagination;
  @JsonKey(name: 'threads')
  List<FrontArticleModel> articles;

  ThreadSearchModel(this.pagination, this.articles);

  factory ThreadSearchModel.fromJson(Map<String, dynamic> json) => _$ThreadSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadSearchModelToJson(this);
}
