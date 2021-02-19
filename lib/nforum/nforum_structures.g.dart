// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nforum_structures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WelcomeInfo _$WelcomeInfoFromJson(Map<String, dynamic> json) {
  return WelcomeInfo(
    json['ver'] as int,
    json['url'] as String,
    json['sign'] as String,
  );
}

Map<String, dynamic> _$WelcomeInfoToJson(WelcomeInfo instance) =>
    <String, dynamic>{
      'ver': instance.ver,
      'url': instance.url,
      'sign': instance.sign,
    };

OAuthAccessInfo _$OAuthAccessInfoFromJson(Map<String, dynamic> json) {
  return OAuthAccessInfo(
    json['access_token'] as String,
    json['expires_in'] as int,
  );
}

Map<String, dynamic> _$OAuthAccessInfoToJson(OAuthAccessInfo instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
    };

OAuthErrorInfo _$OAuthErrorInfoFromJson(Map<String, dynamic> json) {
  return OAuthErrorInfo(
    json['code'] as int,
    json['msg'] as String,
  );
}

Map<String, dynamic> _$OAuthErrorInfoToJson(OAuthErrorInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
    };

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) {
  return StatusModel(
    json['status'] as bool,
  );
}

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['id'] as String,
    json['user_name'] as String,
    json['face_url'] as String,
  )
    ..faceWidth = json['face_width'] as int
    ..faceHeight = json['face_height'] as int
    ..gender = json['gender'] as String
    ..astro = json['astro'] as String
    ..life = json['life'] as int
    ..qq = json['qq'] as String
    ..msn = json['msn'] as String
    ..homePage = json['home_page'] as String
    ..level = json['level'] as String
    ..isOnline = json['is_online'] as bool
    ..postCount = json['post_count'] as int
    ..lastLoginTime = json['last_login_time'] as int
    ..lastLoginIp = json['last_login_ip'] as String
    ..isHide = json['is_hide'] as bool
    ..isRegister = json['is_register'] as bool
    ..score = json['score'] as int
    ..followNum = json['follow_num'] as int
    ..fansNum = json['fans_num'] as int
    ..isFollow = json['is_follow'] as bool
    ..isFan = json['is_fan'] as bool;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'face_url': instance.faceUrl,
      'face_width': instance.faceWidth,
      'face_height': instance.faceHeight,
      'gender': instance.gender,
      'astro': instance.astro,
      'life': instance.life,
      'qq': instance.qq,
      'msn': instance.msn,
      'home_page': instance.homePage,
      'level': instance.level,
      'is_online': instance.isOnline,
      'post_count': instance.postCount,
      'last_login_time': instance.lastLoginTime,
      'last_login_ip': instance.lastLoginIp,
      'is_hide': instance.isHide,
      'is_register': instance.isRegister,
      'score': instance.score,
      'follow_num': instance.followNum,
      'fans_num': instance.fansNum,
      'is_follow': instance.isFollow,
      'is_fan': instance.isFan,
    };

UploadedModel _$UploadedModelFromJson(Map<String, dynamic> json) {
  return UploadedModel(
    json['name'] as String,
    json['url'] as String,
    json['size'] as String,
    json['thumbnail_small'] as String,
    json['thumbnail_middle'] as String,
    json['used'] as bool,
  );
}

Map<String, dynamic> _$UploadedModelToJson(UploadedModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'size': instance.size,
      'thumbnail_small': instance.thumbnailSmall,
      'thumbnail_middle': instance.thumbnailMiddle,
      'used': instance.used,
    };

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) {
  return AttachmentModel(
    (json['file'] as List)
        ?.map((e) => e == null
            ? null
            : UploadedModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['remain_space'] as String,
    json['remain_count'] as int,
  );
}

Map<String, dynamic> _$AttachmentModelToJson(AttachmentModel instance) =>
    <String, dynamic>{
      'file': instance.file,
      'remain_space': instance.remainSpace,
      'remain_count': instance.remainCount,
    };

ToptenModel _$ToptenModelFromJson(Map<String, dynamic> json) {
  return ToptenModel(
    name: json['name'] as String,
    title: json['title'] as String,
    time: json['time'] as int,
    article: (json['article'] as List)
        ?.map((e) => e == null
            ? null
            : FrontArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ToptenModelToJson(ToptenModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'time': instance.time,
      'article': instance.article,
    };

FrontArticleModel _$FrontArticleModelFromJson(Map<String, dynamic> json) {
  return FrontArticleModel(
    id: json['id'] as int,
    groupId: json['group_id'],
    replyId: json['reply_id'] as int,
    flag: json['flag'] as String,
    position: json['position'] as int,
    isTop: json['is_top'] as bool,
    isSubject: json['is_subject'] as bool,
    hasAttachment: json['has_attachment'] as bool,
    isAdmin: json['is_admin'] as bool,
    title: json['title'] as String,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    postTime: json['post_time'],
    boardName: json['board_name'],
    boardDescription: json['board_description'] as String,
    content: json['content'] as String,
    attachment: json['attachment'] == null
        ? null
        : AttachmentModel.fromJson(json['attachment'] as Map<String, dynamic>),
    replyCount: json['reply_count'] as int,
    lastReplyUserId: json['last_reply_user_id'] as String,
    lastReplyTime: json['last_reply_time'] as int,
    idCount: json['id_count'] as String,
  );
}

Map<String, dynamic> _$FrontArticleModelToJson(FrontArticleModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'board_name': instance.boardName,
      'id': instance.id,
      'reply_id': instance.replyId,
      'flag': instance.flag,
      'position': instance.position,
      'is_top': instance.isTop,
      'is_subject': instance.isSubject,
      'has_attachment': instance.hasAttachment,
      'is_admin': instance.isAdmin,
      'board_description': instance.boardDescription,
      'content': instance.content,
      'attachment': instance.attachment,
      'reply_count': instance.replyCount,
      'last_reply_user_id': instance.lastReplyUserId,
      'last_reply_time': instance.lastReplyTime,
      'id_count': instance.idCount,
    };

TimelineModel _$TimelineModelFromJson(Map<String, dynamic> json) {
  return TimelineModel(
    article: (json['article'] as List)
        ?.map((e) => e == null
            ? null
            : FrontArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TimelineModelToJson(TimelineModel instance) =>
    <String, dynamic>{
      'article': instance.article,
      'pagination': instance.pagination,
    };

ArticleBaseModel _$ArticleBaseModelFromJson(Map<String, dynamic> json) {
  return ArticleBaseModel(
    groupId: json['group_id'],
    title: json['title'] as String,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    postTime: json['post_time'],
    boardName: json['board_name'],
  );
}

Map<String, dynamic> _$ArticleBaseModelToJson(ArticleBaseModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'board_name': instance.boardName,
    };

UserListModel _$UserListModelFromJson(Map<String, dynamic> json) {
  return UserListModel(
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    article: (json['user'] as List)
        ?.map((e) =>
            e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserListModelToJson(UserListModel instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'user': instance.article,
    };

ThreadArticleModel _$ThreadArticleModelFromJson(Map<String, dynamic> json) {
  return ThreadArticleModel(
    id: json['id'] as int,
    groupId: json['group_id'],
    replyId: json['reply_id'] as int,
    flag: json['flag'] as String,
    position: json['position'] as int,
    isTop: json['is_top'] as bool,
    isSubject: json['is_subject'] as bool,
    hasAttachment: json['has_attachment'] as bool,
    isAdmin: json['is_admin'] as bool,
    title: json['title'] as String,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    postTime: json['post_time'],
    boardName: json['board_name'],
    boardDescription: json['board_description'] as String,
    content: json['content'] as String,
    attachment: json['attachment'] == null
        ? null
        : AttachmentModel.fromJson(json['attachment'] as Map<String, dynamic>),
    likeSum: json['like_sum'] as String,
    isLiked: json['is_liked'] as bool,
    votedownSum: json['votedown_sum'] as String,
    isVotedown: json['is_votedown'] as bool,
    hiddenByVotedown: json['hidden_by_votedown'] as bool,
  );
}

Map<String, dynamic> _$ThreadArticleModelToJson(ThreadArticleModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'board_name': instance.boardName,
      'id': instance.id,
      'reply_id': instance.replyId,
      'flag': instance.flag,
      'position': instance.position,
      'is_top': instance.isTop,
      'is_subject': instance.isSubject,
      'has_attachment': instance.hasAttachment,
      'is_admin': instance.isAdmin,
      'board_description': instance.boardDescription,
      'content': instance.content,
      'attachment': instance.attachment,
      'like_sum': instance.likeSum,
      'is_liked': instance.isLiked,
      'votedown_sum': instance.votedownSum,
      'is_votedown': instance.isVotedown,
      'hidden_by_votedown': instance.hiddenByVotedown,
    };

LikeArticleModel _$LikeArticleModelFromJson(Map<String, dynamic> json) {
  return LikeArticleModel(
    id: json['id'] as int,
    groupId: json['group_id'],
    replyId: json['reply_id'] as int,
    flag: json['flag'] as String,
    position: json['position'] as int,
    isTop: json['is_top'] as bool,
    isSubject: json['is_subject'] as bool,
    hasAttachment: json['has_attachment'] as bool,
    isAdmin: json['is_admin'] as bool,
    title: json['title'] as String,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    postTime: json['post_time'],
    boardName: json['board_name'],
    boardDescription: json['board_description'] as String,
    content: json['content'] as String,
    attachment: json['attachment'] == null
        ? null
        : AttachmentModel.fromJson(json['attachment'] as Map<String, dynamic>),
    likeSum: json['like_sum'] as String,
    isLiked: json['is_liked'] as bool,
  )..isVotedown = json['isVotedown'] as bool;
}

Map<String, dynamic> _$LikeArticleModelToJson(LikeArticleModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'board_name': instance.boardName,
      'id': instance.id,
      'reply_id': instance.replyId,
      'flag': instance.flag,
      'position': instance.position,
      'is_top': instance.isTop,
      'is_subject': instance.isSubject,
      'has_attachment': instance.hasAttachment,
      'is_admin': instance.isAdmin,
      'board_description': instance.boardDescription,
      'content': instance.content,
      'attachment': instance.attachment,
      'like_sum': instance.likeSum,
      'is_liked': instance.isLiked,
      'isVotedown': instance.isVotedown,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) {
  return PaginationModel(
    json['page_all_count'] as int,
    json['page_current_count'] as int,
    json['item_page_count'] as int,
    json['item_all_count'] as int,
  );
}

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'page_all_count': instance.pageAllCount,
      'page_current_count': instance.pageCurrentCount,
      'item_page_count': instance.itemPageCount,
      'item_all_count': instance.itemAllCount,
    };

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) {
  return ThreadModel(
    id: json['id'] as int,
    groupId: json['group_id'] as int,
    replyId: json['reply_id'] as int,
    flag: json['flag'] as String,
    position: json['position'] as int,
    isTop: json['is_top'] as bool,
    isSubject: json['is_subject'] as bool,
    hasAttachment: json['has_attachment'] as bool,
    isAdmin: json['is_admin'] as bool,
    title: json['title'] as String,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    postTime: json['post_time'] as int,
    boardName: json['board_name'] as String,
    boardDescription: json['board_description'] as String,
    likeSum: json['like_sum'] as String,
    isLiked: json['is_liked'] as bool,
    votedownSum: json['votedown_sum'] as String,
    isVotedown: json['is_votedown'] as bool,
    hiddenByVotedown: json['hidden_by_votedown'] as bool,
    collect: json['collect'] as bool,
    replyCount: json['reply_count'] as int,
    lastReplyUserId: json['last_reply_user_id'] as String,
    lastReplyTime: json['last_reply_time'] as int,
    likeArticles: (json['like_articles'] as List)
        ?.map((e) => e == null
            ? null
            : LikeArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    article: (json['article'] as List)
        ?.map((e) => e == null
            ? null
            : ThreadArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'reply_id': instance.replyId,
      'flag': instance.flag,
      'position': instance.position,
      'is_top': instance.isTop,
      'is_subject': instance.isSubject,
      'has_attachment': instance.hasAttachment,
      'is_admin': instance.isAdmin,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'board_name': instance.boardName,
      'board_description': instance.boardDescription,
      'like_sum': instance.likeSum,
      'is_liked': instance.isLiked,
      'votedown_sum': instance.votedownSum,
      'is_votedown': instance.isVotedown,
      'hidden_by_votedown': instance.hiddenByVotedown,
      'collect': instance.collect,
      'reply_count': instance.replyCount,
      'last_reply_user_id': instance.lastReplyUserId,
      'last_reply_time': instance.lastReplyTime,
      'like_articles': instance.likeArticles,
      'pagination': instance.pagination,
      'article': instance.article,
    };

BetCategoriesModel _$BetCategoriesModelFromJson(Map<String, dynamic> json) {
  return BetCategoriesModel(
    (json['category'] as List)
        ?.map((e) => e == null
            ? null
            : BetCategoryModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BetCategoriesModelToJson(BetCategoriesModel instance) =>
    <String, dynamic>{
      'category': instance.category,
    };

BetCategoryModel _$BetCategoryModelFromJson(Map<String, dynamic> json) {
  return BetCategoryModel(
    json['cid'] as int,
    json['name'] as String,
    json['show'] as bool,
  );
}

Map<String, dynamic> _$BetCategoryModelToJson(BetCategoryModel instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'name': instance.name,
      'show': instance.show,
    };

BetItemModel _$BetItemModelFromJson(Map<String, dynamic> json) {
  return BetItemModel(
    json['biid'] as String,
    json['label'] as String,
    json['num'] as String,
    json['score'] as String,
    json['percent'] as String,
  );
}

Map<String, dynamic> _$BetItemModelToJson(BetItemModel instance) =>
    <String, dynamic>{
      'biid': instance.biid,
      'label': instance.label,
      'num': instance.number,
      'score': instance.score,
      'percent': instance.percent,
    };

MyBetItemModel _$MyBetItemModelFromJson(Map<String, dynamic> json) {
  return MyBetItemModel(
    json['uid'] as String,
    json['biid'] as String,
    json['score'] as String,
    json['bonus'] as int,
    json['result'] as String,
  );
}

Map<String, dynamic> _$MyBetItemModelToJson(MyBetItemModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'biid': instance.biid,
      'score': instance.score,
      'bonus': instance.bonus,
      'result': instance.result,
    };

BetModel _$BetModelFromJson(Map<String, dynamic> json) {
  return BetModel(
    json['bid'] as String,
    json['cate'] as String,
    json['title'] as String,
    json['desc'] as String,
    json['start'] as String,
    json['end'] as String,
    json['num'] as String,
    json['limit'] as String,
    json['discount'] as int,
    json['score'] as String,
    json['aid'] as String,
    json['result'] as String,
    json['isEnd'] as bool,
    json['isDel'] as bool,
    json['hasResult'] as bool,
    (json['bitems'] as List)
        ?.map((e) =>
            e == null ? null : BetItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['mybet'] == null
        ? null
        : MyBetItemModel.fromJson(json['mybet'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BetModelToJson(BetModel instance) => <String, dynamic>{
      'bid': instance.bid,
      'cate': instance.cate,
      'title': instance.title,
      'desc': instance.desc,
      'start': instance.start,
      'end': instance.end,
      'num': instance.number,
      'limit': instance.limit,
      'discount': instance.discount,
      'score': instance.score,
      'aid': instance.aid,
      'result': instance.result,
      'isEnd': instance.isEnd,
      'isDel': instance.isDel,
      'hasResult': instance.hasResult,
      'bitems': instance.bitems,
      'mybet': instance.mybet,
    };

BetListModel _$BetListModelFromJson(Map<String, dynamic> json) {
  return BetListModel(
    json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    (json['bets'] as List)
        ?.map((e) =>
            e == null ? null : BetModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['title'] as String,
  );
}

Map<String, dynamic> _$BetListModelToJson(BetListModel instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'bets': instance.article,
      'title': instance.title,
    };

BetRankItemModel _$BetRankItemModelFromJson(Map<String, dynamic> json) {
  return BetRankItemModel(
    json['uid'] as String,
    json['total'] as String,
    json['win'] as String,
    json['rate'] as String,
    json['score'] as String,
  );
}

Map<String, dynamic> _$BetRankItemModelToJson(BetRankItemModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'total': instance.total,
      'win': instance.win,
      'rate': instance.rate,
      'score': instance.score,
    };

BetRankListModel _$BetRankListModelFromJson(Map<String, dynamic> json) {
  return BetRankListModel(
    (json['types'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    (json['rank'] as List)
        ?.map((e) => e == null
            ? null
            : BetRankItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BetRankListModelToJson(BetRankListModel instance) =>
    <String, dynamic>{
      'types': instance.types,
      'rank': instance.rank,
    };

VoteItemModel _$VoteItemModelFromJson(Map<String, dynamic> json) {
  return VoteItemModel(
    json['viid'] as String,
    json['label'] as String,
    json['num'] as String,
  );
}

Map<String, dynamic> _$VoteItemModelToJson(VoteItemModel instance) =>
    <String, dynamic>{
      'viid': instance.viid,
      'label': instance.label,
      'num': instance.number,
    };

VoteStatusModel _$VoteStatusModelFromJson(Map<String, dynamic> json) {
  return VoteStatusModel(
    json['time'] as String,
    json['viid'],
  );
}

Map<String, dynamic> _$VoteStatusModelToJson(VoteStatusModel instance) =>
    <String, dynamic>{
      'time': instance.time,
      'viid': instance.viid,
    };

VoteModel _$VoteModelFromJson(Map<String, dynamic> json) {
  return VoteModel(
    json['vid'] as String,
    json['title'] as String,
    json['start'] as String,
    json['end'] as String,
    json['user_count'] as String,
    json['vote_count'] as int,
    json['type'] as String,
    json['limit'] as String,
    json['aid'] as String,
    json['is_end'] as bool,
    json['is_deleted'] as bool,
    json['is_result_voted'] as bool,
    json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    json['vote_status'],
    (json['options'] as List)
        ?.map((e) => e == null
            ? null
            : VoteItemModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VoteModelToJson(VoteModel instance) => <String, dynamic>{
      'vid': instance.vid,
      'title': instance.title,
      'start': instance.start,
      'end': instance.end,
      'user_count': instance.userCount,
      'vote_count': instance.voteCount,
      'type': instance.type,
      'limit': instance.limit,
      'aid': instance.aid,
      'is_end': instance.isEnd,
      'is_deleted': instance.isDel,
      'is_result_voted': instance.isResultVoted,
      'user': instance.user,
      'vote_status': instance.voteStatus,
      'options': instance.options,
    };

VoteListModel _$VoteListModelFromJson(Map<String, dynamic> json) {
  return VoteListModel(
    json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    (json['votes'] as List)
        ?.map((e) =>
            e == null ? null : VoteModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$VoteListModelToJson(VoteListModel instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'votes': instance.article,
    };

BannerElementModel _$BannerElementModelFromJson(Map<String, dynamic> json) {
  return BannerElementModel(
    json['image_url'] as String,
    json['intro'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$BannerElementModelToJson(BannerElementModel instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'intro': instance.intro,
      'url': instance.url,
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return BannerModel(
    json['count'] as int,
    (json['banners'] as List)
        ?.map((e) => e == null
            ? null
            : BannerElementModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'banners': instance.banners,
    };

SectionModel _$SectionModelFromJson(Map<String, dynamic> json) {
  return SectionModel(
    json['name'] as String,
    json['description'] as String,
    json['is_root'] as bool,
    json['parent'] as String,
    json['sub_section'],
    (json['board'] as List)
        ?.map((e) =>
            e == null ? null : BoardModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SectionModelToJson(SectionModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'is_root': instance.isRoot,
      'parent': instance.parent,
      'sub_section': instance.subSection,
      'board': instance.board,
    };

SectionListModel _$SectionListModelFromJson(Map<String, dynamic> json) {
  return SectionListModel(
    (json['section'] as List)
        ?.map((e) =>
            e == null ? null : SectionModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SectionListModelToJson(SectionListModel instance) =>
    <String, dynamic>{
      'section': instance.sections,
    };

BoardModel _$BoardModelFromJson(Map<String, dynamic> json) {
  return BoardModel(
    name: json['name'] as String,
    manager: json['manager'] as String,
    description: json['description'] as String,
    nameOfClass: json['class'] as String,
    section: json['section'] as String,
    isFavorite: json['is_favorite'] as bool,
    threadsTodayCount: json['threads_today_count'] as int,
    postTodayCount: json['post_today_count'] as int,
    postThreadsCount: json['post_threads_count'] as int,
    postAllCount: json['post_all_count'] as int,
    userOnlineCount: json['user_online_count'] as int,
    userOnlineMaxCount: json['user_online_max_count'] as int,
    userOnlineMaxTime: json['user_online_max_time'] as int,
    isReadOnly: json['is_read_only'] as bool,
    isNoReply: json['is_no_reply'] as bool,
    allowAttachment: json['allow_attachment'] as bool,
    allowAnonymous: json['allow_anonymous'] as bool,
    allowOutgo: json['allow_outgo'] as bool,
    allowPost: json['allow_post'] as bool,
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    article: (json['article'] as List)
        ?.map((e) => e == null
            ? null
            : FrontArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BoardModelToJson(BoardModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'manager': instance.manager,
      'description': instance.description,
      'class': instance.nameOfClass,
      'section': instance.section,
      'is_favorite': instance.isFavorite,
      'threads_today_count': instance.threadsTodayCount,
      'post_today_count': instance.postTodayCount,
      'post_threads_count': instance.postThreadsCount,
      'post_all_count': instance.postAllCount,
      'user_online_count': instance.userOnlineCount,
      'user_online_max_count': instance.userOnlineMaxCount,
      'user_online_max_time': instance.userOnlineMaxTime,
      'is_read_only': instance.isReadOnly,
      'is_no_reply': instance.isNoReply,
      'allow_attachment': instance.allowAttachment,
      'allow_anonymous': instance.allowAnonymous,
      'allow_outgo': instance.allowOutgo,
      'allow_post': instance.allowPost,
      'pagination': instance.pagination,
      'article': instance.article,
    };

FavBoardsModel _$FavBoardsModelFromJson(Map<String, dynamic> json) {
  return FavBoardsModel(
    (json['sub_favorite'] as List)
        ?.map((e) =>
            e == null ? null : BoardModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['section'] as List)
        ?.map((e) =>
            e == null ? null : BoardModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['board'] as List)
        ?.map((e) =>
            e == null ? null : BoardModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FavBoardsModelToJson(FavBoardsModel instance) =>
    <String, dynamic>{
      'sub_favorite': instance.subFavorite,
      'section': instance.section,
      'board': instance.board,
    };

CollectionArticleModel _$CollectionArticleModelFromJson(
    Map<String, dynamic> json) {
  return CollectionArticleModel(
    createdTime: json['createdTime'],
    title: json['title'] as String,
    postTime: json['post_time'],
    boardName: json['bname'],
    number: json['num'],
    groupId: json['gid'],
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CollectionArticleModelToJson(
        CollectionArticleModel instance) =>
    <String, dynamic>{
      'createdTime': instance.createdTime,
      'title': instance.title,
      'post_time': instance.postTime,
      'bname': instance.boardName,
      'num': instance.number,
      'gid': instance.groupId,
      'user': instance.user,
    };

CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) {
  return CollectionModel(
    article: (json['article'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CollectionModelToJson(CollectionModel instance) =>
    <String, dynamic>{
      'article': instance.article,
      'pagination': instance.pagination,
    };

ReferModel _$ReferModelFromJson(Map<String, dynamic> json) {
  return ReferModel(
    index: json['index'] as int,
    id: json['id'] as int,
    groupId: json['group_id'],
    replyId: json['reply_id'] as int,
    boardName: json['board_name'],
    title: json['title'] as String,
    pos: json['pos'] as int,
    user: json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    time: json['time'] as int,
    isRead: json['is_read'] as bool,
  )..postTime = json['post_time'];
}

Map<String, dynamic> _$ReferModelToJson(ReferModel instance) =>
    <String, dynamic>{
      'post_time': instance.postTime,
      'index': instance.index,
      'id': instance.id,
      'group_id': instance.groupId,
      'reply_id': instance.replyId,
      'board_name': instance.boardName,
      'title': instance.title,
      'pos': instance.pos,
      'user': instance.user,
      'time': instance.time,
      'is_read': instance.isRead,
    };

ReferBoxModel _$ReferBoxModelFromJson(Map<String, dynamic> json) {
  return ReferBoxModel(
    description: json['description'] as String,
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    article: (json['article'] as List)
        ?.map((e) =>
            e == null ? null : ReferModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReferBoxModelToJson(ReferBoxModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'pagination': instance.pagination,
      'article': instance.article,
    };

MailModel _$MailModelFromJson(Map<String, dynamic> json) {
  return MailModel(
    json['index'] as int,
    json['is_m'] as bool,
    json['is_read'] as bool,
    json['is_reply'] as bool,
    json['has_attachment'] as bool,
    json['title'] as String,
    json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    json['post_time'] as int,
    json['box_name'] as String,
    json['content'] as String,
    json['attachment'] == null
        ? null
        : AttachmentModel.fromJson(json['attachment'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MailModelToJson(MailModel instance) => <String, dynamic>{
      'index': instance.index,
      'is_m': instance.isM,
      'is_read': instance.isRead,
      'is_reply': instance.isReply,
      'has_attachment': instance.hasAttachment,
      'title': instance.title,
      'user': instance.user,
      'post_time': instance.postTime,
      'box_name': instance.boxName,
      'content': instance.content,
      'attachment': instance.attachment,
    };

MailBoxModel _$MailBoxModelFromJson(Map<String, dynamic> json) {
  return MailBoxModel(
    description: json['description'] as String,
    newNum: json['new_num'] as int,
    pagination: json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    article: (json['mail'] as List)
        ?.map((e) =>
            e == null ? null : MailModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MailBoxModelToJson(MailBoxModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'new_num': instance.newNum,
      'pagination': instance.pagination,
      'mail': instance.article,
    };

BoardSearchModel _$BoardSearchModelFromJson(Map<String, dynamic> json) {
  return BoardSearchModel(
    json['section'],
    (json['board'] as List)
        ?.map((e) =>
            e == null ? null : BoardModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BoardSearchModelToJson(BoardSearchModel instance) =>
    <String, dynamic>{
      'section': instance.section,
      'board': instance.board,
    };

ThreadSearchModel _$ThreadSearchModelFromJson(Map<String, dynamic> json) {
  return ThreadSearchModel(
    json['pagination'] == null
        ? null
        : PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    (json['threads'] as List)
        ?.map((e) => e == null
            ? null
            : FrontArticleModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ThreadSearchModelToJson(ThreadSearchModel instance) =>
    <String, dynamic>{
      'pagination': instance.pagination,
      'threads': instance.articles,
    };
