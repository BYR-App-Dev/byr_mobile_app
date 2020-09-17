import 'package:byr_mobile_app/configurations/configurations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'translator.g.dart';

@JsonSerializable()
class BYRTranslator {
  factory BYRTranslator.fromJson(Map<String, dynamic> json) => _$BYRTranslatorFromJson(json);

  Map<String, dynamic> toJson() => _$BYRTranslatorToJson(this);

  String translatorName;
  String translatorDisplayName;
  String byrTrans;
  String loginUsernameTrans;
  String loginPasswordTrans;
  String loginSubmitTrans;
  String loginForgetPasswordTrans;
  String loginSignUpTrans;
  String logoutTrans;
  String addAccount;
  String toptenTrans;
  String timelineTrans;
  String subscribedTrans;
  String boardmarksTrans;
  String boardTrans;
  String backToBoardTrans;
  String participantsTrans;
  String repliersTrans;
  String noThreadTodayTrans;
  String newThreadTodayTrans;
  String newThreadsTodayTrans;
  String threadTrans;
  String hotRepliesTrans;
  String allRepliesTrans;
  String replycontentTrans;
  String replyingTrans;
  String reportTrans;
  String reportConfirmTrans;
  List<String> positionTrans;
  String submitTrans;
  String aboutTrans;
  String skipTrans;
  String aboutButtonTrans;
  String sectionButtonTrans;
  String collectionTrans;
  String subSectionTrans;
  String downloadImageTrans;
  String saveTrans;
  String confirmTrans;
  String cancelTrans;
  bool boardNameEn;
  String updatedOn;
  String timeTodayTrans;
  String timeYesterdayTrans;
  String stickyTopTrans;
  String search;
  String browseWebPageTrans;
  String anonymous;
  String unAnonymous;
  String themeAuto;
  String themeAdd;
  String themeRemove;
  String succeed;
  String fail;
  String update;
  String newVersion;
  String ignoreVersion;
  String replyReferTrans;
  String atReferTrans;
  String smsTrans;
  String replyTrans;
  String sendTrans;
  String messageTrans;
  String allReadTrans;
  String receiverTrans;
  String titleTrans;
  String contentTrans;
  String nonBlankTrans;
  String sendSuccessTrans;
  String sendFailedTrans;
  String jumpPage;
  String current;
  String page;
  String original;
  String link;
  String pleaseInputPage;
  String downloadAtt;
  String postArticle;
  String uploadLimit;
  String selectBoard;
  String cantFindBoard;
  String uploadExceedLimit;
  String notAllowAtt;
  String upload;
  String camera;
  String gallery;
  String share;
  String onlyAuthor;
  String emoji;
  String color;
  String close;
  String preview;
  String useIPv4;
  String useIPv6;
  String threads;
  String hasFavorite;
  String favorite;
  String removeCollectionTrans;
  String dismissReplyPointerTrans;
  Map<String, String> emojiTrans;
  String audioFileTrans;
  String audioRecordTrans;
  String audioPostWarning;
  String betTrans;
  Map<String, String> betAttriTypesTrans;
  String betOnTrans;
  String betStakeTrans;
  String betPotentialCollectTrans;
  String minimumBetTrans;
  String myTokenBalanceTrans;
  String allinTrans;
  String betEndTrans;
  String voteTypeMultiple;
  String voteTypeSingle;
  String voteLimit;
  String userVoted;
  String resultAfterVote;
  String vote;
  String voteLimitAlert;
  Map<String, String> voteAttriTypesTrans;
  String copy;
  String delete;
  String deleting;
  String deleteSuccess;
  String deleteFailed;
  String edit;
  String hiddenByVotedown;
  String letmeseesee;
  String profilePageName;
  String profileLife;
  String profilePostCount;
  String profileScore;
  String profileLevel;
  String profileState;
  String profileOnline;
  String profileOffline;
  String profileStarSign;
  String profileHomePage;
  String profileQQ;
  String titleKeywords;
  String authorId;
  String timeRage;
  String unlimited;
  String oneWeek;
  String oneMonth;
  String oneYear;
  String attach;
  String withAttach;
  String withoutAttach;
  String searchNoResults;
  String searchHintPart1;
  String searchHintPart2;
  String loadIDLE;
  String loadFailed;
  String loadCan;
  String noMoreData;
  String homePage;
  String discover;
  String me;
  String frontTabSettingsTrans;
  String pullUpToScreenshot;
  String releaseToScreenshot;
  String screenshotFailed;
  String screenshotCaptured;
  String networkExceptionTrans;
  String dataExceptionTrans;
  String toptenScreenshotTrans;
  String screenshotPage;
  String screenshotOverLength;
  String externalBrowser;
  String language;
  String networkType;
  String settings;
  String publicTesting;
  String importThemeNotification;
  String refresherSettings;
  String importRefresherNotification;
  String refresherAdd;
  String downgradeTrans;

  BYRTranslator(
    this.translatorName,
    this.translatorDisplayName,
    this.byrTrans,
    this.loginUsernameTrans,
    this.loginPasswordTrans,
    this.loginSubmitTrans,
    this.loginForgetPasswordTrans,
    this.loginSignUpTrans,
    this.logoutTrans,
    this.addAccount,
    this.toptenTrans,
    this.timelineTrans,
    this.subscribedTrans,
    this.boardmarksTrans,
    this.boardTrans,
    this.backToBoardTrans,
    this.participantsTrans,
    this.repliersTrans,
    this.noThreadTodayTrans,
    this.newThreadTodayTrans,
    this.newThreadsTodayTrans,
    this.threadTrans,
    this.hotRepliesTrans,
    this.allRepliesTrans,
    this.replycontentTrans,
    this.replyingTrans,
    this.reportTrans,
    this.reportConfirmTrans,
    this.positionTrans,
    this.submitTrans,
    this.aboutTrans,
    this.skipTrans,
    this.aboutButtonTrans,
    this.sectionButtonTrans,
    this.collectionTrans,
    this.subSectionTrans,
    this.downloadImageTrans,
    this.saveTrans,
    this.confirmTrans,
    this.cancelTrans,
    this.boardNameEn,
    this.updatedOn,
    this.timeTodayTrans,
    this.timeYesterdayTrans,
    this.stickyTopTrans,
    this.search,
    this.browseWebPageTrans,
    this.anonymous,
    this.unAnonymous,
    this.themeAuto,
    this.themeAdd,
    this.themeRemove,
    this.succeed,
    this.fail,
    this.update,
    this.newVersion,
    this.ignoreVersion,
    this.replyReferTrans,
    this.atReferTrans,
    this.smsTrans,
    this.replyTrans,
    this.sendTrans,
    this.messageTrans,
    this.allReadTrans,
    this.receiverTrans,
    this.titleTrans,
    this.contentTrans,
    this.nonBlankTrans,
    this.sendSuccessTrans,
    this.sendFailedTrans,
    this.jumpPage,
    this.current,
    this.page,
    this.original,
    this.link,
    this.pleaseInputPage,
    this.downloadAtt,
    this.postArticle,
    this.uploadLimit,
    this.selectBoard,
    this.cantFindBoard,
    this.uploadExceedLimit,
    this.notAllowAtt,
    this.upload,
    this.camera,
    this.gallery,
    this.share,
    this.onlyAuthor,
    this.emoji,
    this.color,
    this.close,
    this.preview,
    this.useIPv4,
    this.useIPv6,
    this.threads,
    this.hasFavorite,
    this.favorite,
    this.removeCollectionTrans,
    this.dismissReplyPointerTrans,
    this.emojiTrans,
    this.audioFileTrans,
    this.audioRecordTrans,
    this.audioPostWarning,
    this.betTrans,
    this.betAttriTypesTrans,
    this.betOnTrans,
    this.betStakeTrans,
    this.betPotentialCollectTrans,
    this.minimumBetTrans,
    this.myTokenBalanceTrans,
    this.allinTrans,
    this.betEndTrans,
    this.voteTypeMultiple,
    this.voteTypeSingle,
    this.voteLimit,
    this.userVoted,
    this.resultAfterVote,
    this.vote,
    this.voteLimitAlert,
    this.voteAttriTypesTrans,
    this.copy,
    this.delete,
    this.deleting,
    this.deleteSuccess,
    this.deleteFailed,
    this.edit,
    this.hiddenByVotedown,
    this.letmeseesee,
    this.profilePageName,
    this.profileLife,
    this.profilePostCount,
    this.profileScore,
    this.profileLevel,
    this.profileState,
    this.profileOnline,
    this.profileOffline,
    this.profileStarSign,
    this.profileHomePage,
    this.profileQQ,
    this.titleKeywords,
    this.authorId,
    this.timeRage,
    this.unlimited,
    this.oneWeek,
    this.oneMonth,
    this.oneYear,
    this.attach,
    this.withAttach,
    this.withoutAttach,
    this.searchNoResults,
    this.searchHintPart1,
    this.searchHintPart2,
    this.loadIDLE,
    this.loadFailed,
    this.loadCan,
    this.noMoreData,
    this.homePage,
    this.discover,
    this.me,
    this.frontTabSettingsTrans,
    this.pullUpToScreenshot,
    this.releaseToScreenshot,
    this.screenshotFailed,
    this.screenshotCaptured,
    this.networkExceptionTrans,
    this.dataExceptionTrans,
    this.toptenScreenshotTrans,
    this.screenshotPage,
    this.screenshotOverLength,
    this.externalBrowser,
    this.language,
    this.networkType,
    this.settings,
    this.publicTesting,
    this.importThemeNotification,
    this.refresherSettings,
    this.importRefresherNotification,
    this.refresherAdd,
    this.downgradeTrans,
  );

  BYRTranslator.generate({
    this.translatorName,
    this.translatorDisplayName,
    this.byrTrans,
    this.loginUsernameTrans,
    this.loginPasswordTrans,
    this.loginSubmitTrans,
    this.loginForgetPasswordTrans,
    this.loginSignUpTrans,
    this.logoutTrans,
    this.addAccount,
    this.toptenTrans,
    this.timelineTrans,
    this.subscribedTrans,
    this.boardmarksTrans,
    this.boardTrans,
    this.backToBoardTrans,
    this.participantsTrans,
    this.repliersTrans,
    this.noThreadTodayTrans,
    this.newThreadTodayTrans,
    this.newThreadsTodayTrans,
    this.threadTrans,
    this.hotRepliesTrans,
    this.allRepliesTrans,
    this.replycontentTrans,
    this.replyingTrans,
    this.reportTrans,
    this.reportConfirmTrans,
    this.positionTrans,
    this.submitTrans,
    this.aboutTrans,
    this.skipTrans,
    this.aboutButtonTrans,
    this.sectionButtonTrans,
    this.collectionTrans,
    this.subSectionTrans,
    this.downloadImageTrans,
    this.saveTrans,
    this.confirmTrans,
    this.cancelTrans,
    this.boardNameEn,
    this.updatedOn,
    this.timeTodayTrans,
    this.timeYesterdayTrans,
    this.stickyTopTrans,
    this.search,
    this.browseWebPageTrans,
    this.anonymous,
    this.unAnonymous,
    this.themeAuto,
    this.themeAdd,
    this.themeRemove,
    this.succeed,
    this.fail,
    this.update,
    this.newVersion,
    this.ignoreVersion,
    this.replyReferTrans,
    this.atReferTrans,
    this.smsTrans,
    this.replyTrans,
    this.sendTrans,
    this.messageTrans,
    this.allReadTrans,
    this.receiverTrans,
    this.titleTrans,
    this.contentTrans,
    this.nonBlankTrans,
    this.sendSuccessTrans,
    this.sendFailedTrans,
    this.jumpPage,
    this.current,
    this.page,
    this.original,
    this.link,
    this.pleaseInputPage,
    this.downloadAtt,
    this.postArticle,
    this.uploadLimit,
    this.selectBoard,
    this.cantFindBoard,
    this.uploadExceedLimit,
    this.notAllowAtt,
    this.upload,
    this.camera,
    this.gallery,
    this.share,
    this.onlyAuthor,
    this.emoji,
    this.color,
    this.close,
    this.preview,
    this.useIPv4,
    this.useIPv6,
    this.threads,
    this.hasFavorite,
    this.favorite,
    this.removeCollectionTrans,
    this.dismissReplyPointerTrans,
    this.emojiTrans,
    this.audioFileTrans,
    this.audioRecordTrans,
    this.audioPostWarning,
    this.betTrans,
    this.betAttriTypesTrans,
    this.betOnTrans,
    this.betStakeTrans,
    this.betPotentialCollectTrans,
    this.minimumBetTrans,
    this.myTokenBalanceTrans,
    this.allinTrans,
    this.betEndTrans,
    this.voteTypeMultiple,
    this.voteTypeSingle,
    this.voteLimit,
    this.userVoted,
    this.resultAfterVote,
    this.vote,
    this.voteLimitAlert,
    this.voteAttriTypesTrans,
    this.copy,
    this.delete,
    this.deleting,
    this.deleteSuccess,
    this.deleteFailed,
    this.edit,
    this.hiddenByVotedown,
    this.letmeseesee,
    this.profilePageName,
    this.profileLife,
    this.profilePostCount,
    this.profileScore,
    this.profileLevel,
    this.profileState,
    this.profileOnline,
    this.profileOffline,
    this.profileStarSign,
    this.profileHomePage,
    this.profileQQ,
    this.titleKeywords,
    this.authorId,
    this.timeRage,
    this.unlimited,
    this.oneWeek,
    this.oneMonth,
    this.oneYear,
    this.attach,
    this.withAttach,
    this.withoutAttach,
    this.searchNoResults,
    this.searchHintPart1,
    this.searchHintPart2,
    this.loadIDLE,
    this.loadFailed,
    this.loadCan,
    this.noMoreData,
    this.homePage,
    this.discover,
    this.me,
    this.frontTabSettingsTrans,
    this.pullUpToScreenshot,
    this.releaseToScreenshot,
    this.screenshotFailed,
    this.screenshotCaptured,
    this.networkExceptionTrans,
    this.dataExceptionTrans,
    this.toptenScreenshotTrans,
    this.screenshotPage,
    this.screenshotOverLength,
    this.externalBrowser,
    this.language,
    this.networkType,
    this.settings,
    this.publicTesting,
    this.importThemeNotification,
    this.refresherSettings,
    this.importRefresherNotification,
    this.refresherAdd,
    this.downgradeTrans,
  });

  void fillBy(BYRTranslator bTranslator) {
    this.translatorName ??= bTranslator.translatorName;
    this.translatorDisplayName ??= bTranslator.translatorDisplayName;
    this.byrTrans ??= bTranslator.byrTrans;
    this.loginUsernameTrans ??= bTranslator.loginUsernameTrans;
    this.loginPasswordTrans ??= bTranslator.loginPasswordTrans;
    this.loginSubmitTrans ??= bTranslator.loginSubmitTrans;
    this.loginForgetPasswordTrans ??= bTranslator.loginForgetPasswordTrans;
    this.loginSignUpTrans ??= bTranslator.loginSignUpTrans;
    this.logoutTrans ??= bTranslator.logoutTrans;
    this.addAccount ??= bTranslator.addAccount;
    this.toptenTrans ??= bTranslator.toptenTrans;
    this.timelineTrans ??= bTranslator.timelineTrans;
    this.subscribedTrans ??= bTranslator.subscribedTrans;
    this.boardmarksTrans ??= bTranslator.boardmarksTrans;
    this.boardTrans ??= bTranslator.boardTrans;
    this.backToBoardTrans ??= bTranslator.backToBoardTrans;
    this.participantsTrans ??= bTranslator.participantsTrans;
    this.repliersTrans ??= bTranslator.repliersTrans;
    this.noThreadTodayTrans ??= bTranslator.noThreadTodayTrans;
    this.newThreadTodayTrans ??= bTranslator.newThreadTodayTrans;
    this.newThreadsTodayTrans ??= bTranslator.newThreadsTodayTrans;
    this.threadTrans ??= bTranslator.threadTrans;
    this.hotRepliesTrans ??= bTranslator.hotRepliesTrans;
    this.allRepliesTrans ??= bTranslator.allRepliesTrans;
    this.replycontentTrans ??= bTranslator.replycontentTrans;
    this.replyingTrans ??= bTranslator.replyingTrans;
    this.reportTrans ??= bTranslator.reportTrans;
    this.reportConfirmTrans ??= bTranslator.reportConfirmTrans;
    this.positionTrans ??= bTranslator.positionTrans;
    this.submitTrans ??= bTranslator.submitTrans;
    this.aboutTrans ??= bTranslator.aboutTrans;
    this.skipTrans ??= bTranslator.skipTrans;
    this.aboutButtonTrans ??= bTranslator.aboutButtonTrans;
    this.sectionButtonTrans ??= bTranslator.sectionButtonTrans;
    this.collectionTrans ??= bTranslator.collectionTrans;
    this.subSectionTrans ??= bTranslator.subSectionTrans;
    this.downloadImageTrans ??= bTranslator.downloadImageTrans;
    this.saveTrans ??= bTranslator.saveTrans;
    this.confirmTrans ??= bTranslator.confirmTrans;
    this.cancelTrans ??= bTranslator.cancelTrans;
    this.boardNameEn ??= bTranslator.boardNameEn;
    this.updatedOn ??= bTranslator.updatedOn;
    this.timeTodayTrans ??= bTranslator.timeTodayTrans;
    this.timeYesterdayTrans ??= bTranslator.timeYesterdayTrans;
    this.stickyTopTrans ??= bTranslator.stickyTopTrans;
    this.search ??= bTranslator.search;
    this.browseWebPageTrans ??= bTranslator.browseWebPageTrans;
    this.anonymous ??= bTranslator.anonymous;
    this.unAnonymous ??= bTranslator.unAnonymous;
    this.themeAuto ??= bTranslator.themeAuto;
    this.themeAdd ??= bTranslator.themeAdd;
    this.themeRemove ??= bTranslator.themeRemove;
    this.succeed ??= bTranslator.succeed;
    this.fail ??= bTranslator.fail;
    this.update ??= bTranslator.update;
    this.newVersion ??= bTranslator.newVersion;
    this.ignoreVersion ??= bTranslator.ignoreVersion;
    this.replyReferTrans ??= bTranslator.replyReferTrans;
    this.atReferTrans ??= bTranslator.atReferTrans;
    this.smsTrans ??= bTranslator.smsTrans;
    this.replyTrans ??= bTranslator.replyTrans;
    this.sendTrans ??= bTranslator.sendTrans;
    this.messageTrans ??= bTranslator.messageTrans;
    this.allReadTrans ??= bTranslator.allReadTrans;
    this.receiverTrans ??= bTranslator.receiverTrans;
    this.titleTrans ??= bTranslator.titleTrans;
    this.contentTrans ??= bTranslator.contentTrans;
    this.nonBlankTrans ??= bTranslator.nonBlankTrans;
    this.sendSuccessTrans ??= bTranslator.sendSuccessTrans;
    this.sendFailedTrans ??= bTranslator.sendFailedTrans;
    this.jumpPage ??= bTranslator.jumpPage;
    this.current ??= bTranslator.current;
    this.page ??= bTranslator.page;
    this.original ??= bTranslator.original;
    this.link ??= bTranslator.link;
    this.pleaseInputPage ??= bTranslator.pleaseInputPage;
    this.downloadAtt ??= bTranslator.downloadAtt;
    this.postArticle ??= bTranslator.postArticle;
    this.uploadLimit ??= bTranslator.uploadLimit;
    this.selectBoard ??= bTranslator.selectBoard;
    this.cantFindBoard ??= bTranslator.cantFindBoard;
    this.uploadExceedLimit ??= bTranslator.uploadExceedLimit;
    this.notAllowAtt ??= bTranslator.notAllowAtt;
    this.upload ??= bTranslator.upload;
    this.camera ??= bTranslator.camera;
    this.gallery ??= bTranslator.gallery;
    this.share ??= bTranslator.share;
    this.onlyAuthor ??= bTranslator.onlyAuthor;
    this.emoji ??= bTranslator.emoji;
    this.color ??= bTranslator.color;
    this.close ??= bTranslator.close;
    this.preview ??= bTranslator.preview;
    this.useIPv4 ??= bTranslator.useIPv4;
    this.useIPv6 ??= bTranslator.useIPv6;
    this.threads ??= bTranslator.threads;
    this.hasFavorite ??= bTranslator.hasFavorite;
    this.favorite ??= bTranslator.favorite;
    this.removeCollectionTrans ??= bTranslator.removeCollectionTrans;
    this.dismissReplyPointerTrans ??= bTranslator.dismissReplyPointerTrans;
    this.emojiTrans ??= bTranslator.emojiTrans;
    this.audioFileTrans ??= bTranslator.audioFileTrans;
    this.audioRecordTrans ??= bTranslator.audioRecordTrans;
    this.audioPostWarning ??= bTranslator.audioPostWarning;
    this.betTrans ??= bTranslator.betTrans;
    this.betAttriTypesTrans ??= bTranslator.betAttriTypesTrans;
    this.betOnTrans ??= bTranslator.betOnTrans;
    this.betStakeTrans ??= bTranslator.betStakeTrans;
    this.betPotentialCollectTrans ??= bTranslator.betPotentialCollectTrans;
    this.minimumBetTrans ??= bTranslator.minimumBetTrans;
    this.myTokenBalanceTrans ??= bTranslator.myTokenBalanceTrans;
    this.allinTrans ??= bTranslator.allinTrans;
    this.betEndTrans ??= bTranslator.betEndTrans;
    this.voteTypeMultiple ??= bTranslator.voteTypeMultiple;
    this.voteTypeSingle ??= bTranslator.voteTypeSingle;
    this.voteLimit ??= bTranslator.voteLimit;
    this.userVoted ??= bTranslator.userVoted;
    this.resultAfterVote ??= bTranslator.resultAfterVote;
    this.vote ??= bTranslator.vote;
    this.voteLimitAlert ??= bTranslator.voteLimitAlert;
    this.voteAttriTypesTrans ??= bTranslator.voteAttriTypesTrans;
    this.copy ??= bTranslator.copy;
    this.delete ??= bTranslator.delete;
    this.deleting ??= bTranslator.deleting;
    this.deleteSuccess ??= bTranslator.deleteSuccess;
    this.deleteFailed ??= bTranslator.deleteFailed;
    this.edit ??= bTranslator.edit;
    this.hiddenByVotedown ??= bTranslator.hiddenByVotedown;
    this.letmeseesee ??= bTranslator.letmeseesee;
    this.profilePageName ??= bTranslator.profilePageName;
    this.profileLife ??= bTranslator.profileLife;
    this.profilePostCount ??= bTranslator.profilePostCount;
    this.profileScore ??= bTranslator.profileScore;
    this.profileLevel ??= bTranslator.profileLevel;
    this.profileState ??= bTranslator.profileState;
    this.profileOnline ??= bTranslator.profileOnline;
    this.profileOffline ??= bTranslator.profileOffline;
    this.profileStarSign ??= bTranslator.profileStarSign;
    this.profileHomePage ??= bTranslator.profileHomePage;
    this.profileQQ ??= bTranslator.profileQQ;
    this.titleKeywords ??= bTranslator.titleKeywords;
    this.authorId ??= bTranslator.authorId;
    this.timeRage ??= bTranslator.timeRage;
    this.unlimited ??= bTranslator.unlimited;
    this.oneWeek ??= bTranslator.oneWeek;
    this.oneMonth ??= bTranslator.oneMonth;
    this.oneYear ??= bTranslator.oneYear;
    this.attach ??= bTranslator.attach;
    this.withAttach ??= bTranslator.withAttach;
    this.withoutAttach ??= bTranslator.withoutAttach;
    this.searchNoResults ??= bTranslator.searchNoResults;
    this.searchHintPart1 ??= bTranslator.searchHintPart1;
    this.searchHintPart2 ??= bTranslator.searchHintPart2;
    this.loadIDLE ??= bTranslator.loadIDLE;
    this.loadFailed ??= bTranslator.loadFailed;
    this.loadCan ??= bTranslator.loadCan;
    this.noMoreData ??= bTranslator.noMoreData;
    this.homePage ??= bTranslator.homePage;
    this.discover ??= bTranslator.discover;
    this.me ??= bTranslator.me;
    this.frontTabSettingsTrans ??= bTranslator.frontTabSettingsTrans;
    this.pullUpToScreenshot ??= bTranslator.pullUpToScreenshot;
    this.releaseToScreenshot ??= bTranslator.releaseToScreenshot;
    this.screenshotFailed ??= bTranslator.screenshotFailed;
    this.screenshotCaptured ??= bTranslator.screenshotCaptured;
    this.networkExceptionTrans ??= bTranslator.networkExceptionTrans;
    this.dataExceptionTrans ??= bTranslator.dataExceptionTrans;
    this.toptenScreenshotTrans ??= bTranslator.toptenScreenshotTrans;
    this.screenshotPage ??= bTranslator.screenshotPage;
    this.screenshotOverLength ??= bTranslator.screenshotOverLength;
    this.externalBrowser ??= bTranslator.externalBrowser;
    this.language ??= bTranslator.language;
    this.networkType ??= bTranslator.networkType;
    this.settings ??= bTranslator.settings;
    this.publicTesting ??= bTranslator.publicTesting;
    this.importThemeNotification ??= bTranslator.importThemeNotification;
    this.refresherSettings ??= bTranslator.refresherSettings;
    this.importRefresherNotification ??= bTranslator.importRefresherNotification;
    this.refresherAdd ??= bTranslator.refresherAdd;
    this.downgradeTrans ??= bTranslator.downgradeTrans;
  }

  static BYRTranslator englishTranslator = BYRTranslator.generate(
    byrTrans: "BYR",
    loginUsernameTrans: "username",
    loginPasswordTrans: "password",
    loginSubmitTrans: "submit",
    loginForgetPasswordTrans: "forget pasword?",
    loginSignUpTrans: "signup",
    logoutTrans: "Logout",
    addAccount: "New Account",
    toptenTrans: "Top10",
    timelineTrans: "Timeline",
    subscribedTrans: "Subscribed",
    boardmarksTrans: "Boardmarks",
    boardTrans: "Board",
    backToBoardTrans: "Back to Board",
    participantsTrans: "participants",
    repliersTrans: "repliers",
    noThreadTodayTrans: "no new thread",
    newThreadTodayTrans: "~ new thread",
    newThreadsTodayTrans: "~ new threads",
    threadTrans: "Thread",
    hotRepliesTrans: "hot replies",
    allRepliesTrans: "all replies",
    positionTrans: ["Author", "#1", "#2", "#%"],
    browseWebPageTrans: "Browse Webpage",
    replycontentTrans: "reply content",
    replyingTrans: "reply #%",
    reportTrans: "Report",
    reportConfirmTrans: "Confirm report this ?",
    submitTrans: "Submit",
    aboutButtonTrans: "About",
    sectionButtonTrans: "Sections",
    collectionTrans: "Collection",
    subSectionTrans: "Sub Section",
    aboutTrans:
        "This app is the official mobile client of the BYR BBS (bbs.byr.cn) which is the BBS of Beijing University of Posts and Telecommunications, China(BUPT)." +
            "\n\nThe current version is " +
            AppConfigs.version +
            "\n\nFeedback please post on Advice board" +
            "\n\nThe developers are \nwdjwxh\npaper777 (server-side)\nhuanwoyeye (design)\nMoby22 (design)\ndss886 (Android)\nicyfox (Android)\nfriparia (iOS)\ndarkfrost (iOS)\nnmslwsnd (iOS)\n\nThis app is re-developed in 2019~2020 using Flutter.\n\nRefresh animation credit: \n北邮心跳 by zifeiyu4024\n有空调酱的北邮夏 by buddleia\nmemory of BUPT by cdddemy\n",
    skipTrans: "skip",
    downloadImageTrans: "Download",
    saveTrans: "Save",
    confirmTrans: "Confirm",
    cancelTrans: "Cancel",
    boardNameEn: false,
    updatedOn: "at",
    timeTodayTrans: "% today",
    timeYesterdayTrans: "% yesterday",
    stickyTopTrans: "sticky",
    replyReferTrans: "Reply Me",
    atReferTrans: "@ Me",
    smsTrans: "SMSBox",
    replyTrans: "Reply",
    sendTrans: "Send",
    messageTrans: "Message",
    allReadTrans: "Mark all read？(Not include SMS)",
    receiverTrans: "Receiver",
    titleTrans: "Subject",
    contentTrans: "Content",
    nonBlankTrans: " can't be blank",
    sendSuccessTrans: "Success",
    sendFailedTrans: "Failed, pleaese try later.",
    jumpPage: "Goto Page",
    current: "current ",
    page: "page",
    original: "original ",
    link: "link",
    pleaseInputPage: "Type page num.",
    search: "Search",
    postArticle: "Post",
    uploadLimit: "Upload Images(Size < 5MB)",
    selectBoard: "Select Board",
    cantFindBoard: "Can't find any boards.\nSupport Chinese or English.",
    uploadExceedLimit: "Total size is over 5MB!",
    notAllowAtt: "Current board can't upload",
    upload: "Upload",
    camera: "Camera",
    gallery: "Gallery",
    useIPv4: "Use IPv4",
    useIPv6: "Use IPv6",
    anonymous: "Anonymous",
    unAnonymous: "UnAnonymous",
    threads: "Threads",
    hasFavorite: "Following",
    favorite: "Follow",
    share: "Share",
    onlyAuthor: "Author",
    themeAuto: "Auto",
    themeAdd: "Import Theme",
    themeRemove: "Remove",
    update: "Update",
    newVersion: "New version",
    ignoreVersion: "Ignore this version",
    downloadAtt: "Please Download from PC Web",
    succeed: "Succeeded",
    fail: "Failed",
    removeCollectionTrans: "Remove from collection",
    dismissReplyPointerTrans: "Dismiss reply pointer",
    emojiTrans: {
      "classicsTabTrans": "Classics",
      "yoyociciTabTrans": "YoYo & CiCi",
      "tuzkiTabTrans": "Tuzki",
      "oniontouTabTrans": "Onion Tou",
    },
    audioFileTrans: "Audio",
    audioRecordTrans: "Record",
    audioPostWarning:
        "The content of the audio attachments should be precisely described with text. Otherwise, the BYR forum may delete the post and suspend the account without notice.",
    betTrans: "Bet",
    betAttriTypesTrans: {
      "new": "Open",
      "hist": "Archived",
      "join": "Participated",
    },
    betOnTrans: "Bet on",
    betStakeTrans: "Stake",
    betPotentialCollectTrans: "Potential Collect",
    minimumBetTrans: "Minimum",
    myTokenBalanceTrans: "Token Balance",
    allinTrans: "All-in",
    betEndTrans: "Ended",
    voteTypeMultiple: "can select up to",
    voteTypeSingle: "can select single option",
    voteLimit: " @ options",
    userVoted: " voters",
    resultAfterVote: "vote to show result",
    vote: "cast vote",
    voteLimitAlert: "Please select at least one option and the number of options selected should not over the limit",
    voteAttriTypesTrans: {
      "new": "Open",
      "hot": "Hot",
      "all": "All",
      "me": "My Votes",
      "join": "Participated",
      "list": "List",
    },
    copy: "Copy",
    delete: "Delete",
    deleting: "Deleting",
    deleteSuccess: "Delete Success",
    deleteFailed: "Delete Failed",
    edit: "Edit",
    hiddenByVotedown: "This article is hidden due to the number of votedowns.",
    letmeseesee: "Let me see see!",
    emoji: "Emoji",
    color: "Color",
    close: "Close",
    preview: "Preview",
    profilePageName: "User Profile",
    profileLife: "Life",
    profilePostCount: "Posts",
    profileScore: "Score",
    profileLevel: "Level",
    profileState: "State",
    profileOnline: "Online",
    profileOffline: "Offline",
    profileStarSign: "StarSign",
    profileHomePage: "HomePage",
    profileQQ: "QQ",
    titleKeywords: "Keywords in title",
    authorId: "Author id",
    timeRage: "Time range",
    unlimited: "Unlimited",
    oneWeek: "Past week",
    oneMonth: "Past month",
    oneYear: "Past year",
    attach: "Attach",
    withAttach: "With",
    withoutAttach: "Without",
    searchNoResults: "No results",
    searchHintPart1: "Searched",
    searchHintPart2: "results for you",
    loadIDLE: "Pull up to load.",
    loadFailed: "Load failed, plz retry!",
    loadCan: "Cancel tap to load!",
    noMoreData: "No more data!",
    homePage: 'Home',
    discover: 'Discover',
    me: 'Me',
    frontTabSettingsTrans: 'Tab Settings',
    pullUpToScreenshot: 'pull up for screenshot',
    releaseToScreenshot: 'release for screenshot',
    screenshotFailed: 'screenshot failed',
    screenshotCaptured: 'screenshot captured',
    networkExceptionTrans: 'Network Exception',
    dataExceptionTrans: 'Data Exception',
    toptenScreenshotTrans: 'Top10 pull up to screenshot',
    screenshotPage: "Screenshot",
    screenshotOverLength: "Screenshot might be fractional",
    externalBrowser: "open with system browser",
    language: "Language",
    networkType: "Network",
    settings: "Settings",
    publicTesting: "Testing",
    importThemeNotification: "Please remove old instance before importing one with same name",
    refresherSettings: "Refresher Settings",
    importRefresherNotification: "Please remove old instance before importing one with same name",
    refresherAdd: "Import Refresher",
    downgradeTrans: "Downgrade",
  );

  static BYRTranslator simplifiedChineseTranslator = BYRTranslator.generate(
    byrTrans: "北邮人论坛",
    loginUsernameTrans: "用户名",
    loginPasswordTrans: "密码",
    loginSubmitTrans: "登录",
    loginForgetPasswordTrans: "忘记密码?",
    loginSignUpTrans: "注册",
    logoutTrans: "登出",
    addAccount: "添加账号",
    toptenTrans: "今日十大",
    timelineTrans: "时间线",
    subscribedTrans: "订阅线",
    boardmarksTrans: "收藏版面",
    boardTrans: "版面",
    backToBoardTrans: "返回版面",
    participantsTrans: "人参与",
    repliersTrans: "人回复",
    noThreadTodayTrans: "今日没有新帖",
    newThreadTodayTrans: "今日有~只新帖",
    newThreadsTodayTrans: "今日有~只新帖",
    threadTrans: "浏览帖子",
    hotRepliesTrans: "热门回复",
    allRepliesTrans: "全部回复",
    positionTrans: ["楼主", "沙发", "板凳", "%楼"],
    browseWebPageTrans: "浏览网页",
    replycontentTrans: "回复内容",
    replyingTrans: "回复 %楼",
    reportTrans: "举报",
    reportConfirmTrans: "确定举报该帖子吗？",
    submitTrans: "发送",
    aboutButtonTrans: "关于",
    sectionButtonTrans: "分区",
    collectionTrans: "收藏夹",
    subSectionTrans: "子分区",
    aboutTrans: "此应用为北京邮电大学北邮人论坛的官方客户端。" +
        "\n\n当前版本 " +
        AppConfigs.version +
        "\n\n意见反馈请发送至意见与建议版" +
        "\n\n开发者为: \nwdjwxh\npaper777 (后台)\nhuanwoyeye (设计)\nMoby22 (设计)\ndss886 (Android)\nicyfox (Android)\nfriparia (iOS)\ndarkfrost (iOS)\nnmslwsnd (iOS)\n\n此应用于2019~2020年使用Flutter重新开发。\n\n刷新动画鸣谢: \n北邮心跳 by zifeiyu4024\n有空调酱的北邮夏 by buddleia\nmemory of BUPT by cdddemy\n",
    skipTrans: "跳过",
    downloadImageTrans: "下载",
    saveTrans: "保存",
    confirmTrans: "确定",
    cancelTrans: "取消",
    boardNameEn: false,
    updatedOn: "更新于",
    timeTodayTrans: "今天 %",
    timeYesterdayTrans: "昨天 %",
    stickyTopTrans: "置顶",
    replyReferTrans: "回复提醒",
    atReferTrans: "@提醒",
    smsTrans: "站内信",
    replyTrans: "回复",
    sendTrans: "发送",
    messageTrans: "消息",
    allReadTrans: "确认全部已读吗？(不包括站内信)",
    receiverTrans: "收件人",
    titleTrans: "主题",
    contentTrans: "内容",
    nonBlankTrans: "不能为空",
    sendSuccessTrans: "发送成功",
    sendFailedTrans: "发送失败,请稍后重试",
    jumpPage: "跳页",
    current: "当前",
    page: "页",
    original: "原",
    link: "链接",
    pleaseInputPage: "请输入页码",
    search: "搜索",
    postArticle: "发表帖子",
    uploadLimit: "上传图片(总大小不超过5MB)",
    selectBoard: "请点击选择发表版面",
    cantFindBoard: "找不到你要的版面\n用中文或者英文都可以哦",
    uploadExceedLimit: "附件总大小超过5MB,请重新选择!",
    notAllowAtt: "当前版面不能上传附件,请移除",
    upload: "上传",
    camera: "相机",
    gallery: "相册",
    useIPv4: "使用IPv4网络",
    useIPv6: "使用IPv6网络",
    anonymous: "匿名",
    unAnonymous: "取消匿名",
    threads: "帖子",
    hasFavorite: "已关注",
    favorite: "关注",
    share: "分享",
    onlyAuthor: "只看楼主",
    themeAuto: "跟随系统",
    themeAdd: "导入配色",
    themeRemove: "移除",
    update: "更新",
    newVersion: "新版本",
    ignoreVersion: "忽略此版本",
    downloadAtt: "附件请从网页版下载",
    succeed: "成功",
    fail: "失败",
    removeCollectionTrans: "移出收藏夹",
    dismissReplyPointerTrans: "解除回复",
    emojiTrans: {
      "classicsTabTrans": "经典",
      "yoyociciTabTrans": "悠嘻猴",
      "tuzkiTabTrans": "兔斯基",
      "oniontouTabTrans": "洋葱头",
    },
    audioFileTrans: "音频",
    audioRecordTrans: "录音",
    audioPostWarning: "音频附件的内容应准确地在文中用文字描述。否则，北邮人论坛有权删除该帖子并封禁帐户，恕不另行通知。",
    betTrans: "竞猜",
    betAttriTypesTrans: {
      "new": "当前竞猜",
      "hist": "历史竞猜",
      "join": "参与的竞猜",
    },
    betOnTrans: "投注",
    betStakeTrans: "已投注",
    betPotentialCollectTrans: "预计收益",
    minimumBetTrans: "投注下限",
    myTokenBalanceTrans: "可用筹码",
    allinTrans: "全梭",
    betEndTrans: "已截止",
    voteTypeMultiple: "多选",
    voteTypeSingle: "单选",
    voteLimit: "最多投@票",
    userVoted: "人参与",
    resultAfterVote: "投票后显示结果",
    vote: "投票",
    voteLimitAlert: "请选择至少一个选项，且选择的选项数不要超过此投票的限制",
    voteAttriTypesTrans: {
      "new": "最新投票",
      "hot": "热门投票",
      "all": "全部投票",
      "me": "我的投票",
      "join": "参与的投票",
      "list": "用户发起的投票",
    },
    copy: "复制",
    delete: "删除",
    deleting: "正在删除",
    deleteSuccess: "删除成功",
    deleteFailed: "删除失败",
    edit: "编辑",
    hiddenByVotedown: "由于点踩的用户过多，此条回复被隐藏。",
    letmeseesee: "让我看看!",
    emoji: "表情",
    color: "颜色",
    close: "关闭",
    preview: "预览",
    profilePageName: "用户资料",
    profileLife: "生命力",
    profilePostCount: "文章",
    profileScore: "积分",
    profileLevel: "等级",
    profileState: "状态",
    profileOnline: "在线",
    profileOffline: "离线",
    profileStarSign: "星座",
    profileHomePage: "主页",
    profileQQ: "QQ",
    titleKeywords: "标题关键词",
    authorId: "作者ID",
    timeRage: "时间范围",
    unlimited: "不限",
    oneWeek: "一周内",
    oneMonth: "一个月内",
    oneYear: "一年内",
    attach: "附件",
    withAttach: "有附件",
    withoutAttach: "无附件",
    searchNoResults: "未能找到符合条件的文章",
    searchHintPart1: "已为您找到",
    searchHintPart2: "个相关结果",
    loadIDLE: "上拉加载",
    loadFailed: "加载失败，请重试！",
    loadCan: "松手加载更多!",
    noMoreData: "没有更多数据了!",
    homePage: '首页',
    discover: '发现',
    me: '我',
    frontTabSettingsTrans: '首页标签设置',
    pullUpToScreenshot: '上拉截图',
    releaseToScreenshot: '松手开始截图',
    screenshotFailed: '截图失败',
    screenshotCaptured: '截图成功',
    networkExceptionTrans: '网络异常',
    dataExceptionTrans: '数据异常',
    toptenScreenshotTrans: '十大上拉截图',
    screenshotPage: "截图",
    screenshotOverLength: "内容太长可能会截取不全",
    externalBrowser: "系统浏览器打开",
    language: "语言",
    networkType: "网络",
    settings: "设置",
    publicTesting: "公测",
    importThemeNotification: "请在导入同名配色前先移除旧配色",
    refresherSettings: "刷新动画设置",
    importRefresherNotification: "请在导入同名刷新动画前先移除旧刷新动画",
    refresherAdd: "导入刷新动画",
    downgradeTrans: "降级版本",
  );

  static BYRTranslator traditionalChineseTranslator = BYRTranslator.generate(
    byrTrans: "北郵人論壇",
    loginUsernameTrans: "用戶名",
    loginPasswordTrans: "密碼",
    loginSubmitTrans: "登入",
    loginForgetPasswordTrans: "忘記密碼?",
    loginSignUpTrans: "注冊",
    logoutTrans: "登出",
    addAccount: "添加賬號",
    toptenTrans: "今日十大",
    timelineTrans: "時間綫",
    subscribedTrans: "訂閱綫",
    boardmarksTrans: "收藏版面",
    boardTrans: "版面",
    backToBoardTrans: "返回版面",
    participantsTrans: "人發言",
    repliersTrans: "人回復",
    noThreadTodayTrans: "今日沒有新帖",
    newThreadTodayTrans: "今日有~只新帖",
    newThreadsTodayTrans: "今日有~只新帖",
    threadTrans: "閲覽帖子",
    hotRepliesTrans: "最夯回復",
    allRepliesTrans: "所有回復",
    positionTrans: ["原PO", "#1", "#2", "#%"],
    browseWebPageTrans: "瀏覽網頁",
    replycontentTrans: "回復内容",
    replyingTrans: "回復 #%",
    reportTrans: "舉報",
    reportConfirmTrans: "確定舉報該貼子嗎？",
    submitTrans: "提交",
    aboutButtonTrans: "關於",
    sectionButtonTrans: "分區",
    collectionTrans: "收藏夾",
    subSectionTrans: "子分區",
    aboutTrans: "此應用程式為北京郵電大學北郵人論壇之官方客戶端。" +
        "\n\n當前版本 " +
        AppConfigs.version +
        "\n\n意見反饋請發送于意見與建議版" +
        "\n\n開發者為: \nwdjwxh\npaper777 (伺服器)\nhuanwoyeye (設計)\nMoby22 (設計)\ndss886 (Android)\nicyfox (Android)\nfriparia (iOS)\ndarkfrost (iOS)\nnmslwsnd (iOS)\n\n此應用程式于2019~2020年基於Flutter重新開發。刷新動畫鳴謝: \n北邮心跳 by zifeiyu4024\n有空调酱的北邮夏 by buddleia\nmemory of BUPT by cdddemy\n",
    skipTrans: "跳過",
    downloadImageTrans: "下載",
    saveTrans: "儲存",
    confirmTrans: "確定",
    cancelTrans: "取消",
    boardNameEn: false,
    updatedOn: "更新于",
    timeTodayTrans: "今日 %",
    timeYesterdayTrans: "昨日 %",
    stickyTopTrans: "置頂",
    replyReferTrans: "回复提醒",
    atReferTrans: "@提醒",
    smsTrans: "站內短信",
    replyTrans: "回复",
    sendTrans: "發送",
    messageTrans: "訊息",
    allReadTrans: "確認全部已讀嗎？(不包括站內短信)",
    receiverTrans: "收件人",
    titleTrans: "主題",
    contentTrans: "內容",
    nonBlankTrans: "不能為空",
    sendSuccessTrans: "發送成功",
    sendFailedTrans: "發送失敗，請稍候重試",
    jumpPage: "跳頁",
    current: "當前",
    page: "頁",
    original: "原",
    link: "链接",
    pleaseInputPage: "請輸入頁碼",
    search: "搜索",
    postArticle: "發表貼子",
    uploadLimit: "上傳圖片(總大小不超過5MB)",
    selectBoard: "請點擊選擇發表版面",
    cantFindBoard: "找不到你要的版面\n用中文或者英文都可以哦",
    uploadExceedLimit: "附件總大小超過5MB,請重新選擇!",
    notAllowAtt: "當前版面不能上傳附件,請移除",
    upload: "上傳",
    camera: "相機",
    gallery: "相冊",
    useIPv4: "使用IPv4網絡",
    useIPv6: "使用IPv6網絡",
    anonymous: "匿名",
    unAnonymous: "取消匿名",
    threads: "貼子",
    hasFavorite: "已關注",
    favorite: "關注",
    share: "分享",
    onlyAuthor: "只看樓主",
    themeAuto: "跟隨系統",
    themeAdd: "導入配色",
    themeRemove: "移除",
    update: "更新",
    newVersion: "新版本",
    ignoreVersion: "忽略此版本",
    downloadAtt: "附件請從網頁版下載",
    succeed: "完成",
    fail: "失敗",
    removeCollectionTrans: "移出收藏夾",
    dismissReplyPointerTrans: "解除回复",
    emojiTrans: {
      "classicsTabTrans": "經典",
      "yoyociciTabTrans": "悠嘻猴",
      "tuzkiTabTrans": "兔斯基",
      "oniontouTabTrans": "洋蔥頭",
    },
    audioFileTrans: "音頻",
    audioRecordTrans: "錄音",
    audioPostWarning: "音頻附件的內容應準確地在文中用文字描述。否則，北郵人論壇有權刪除該帖子並封禁帳戶，恕不另行通知。",
    betTrans: "競猜",
    betAttriTypesTrans: {
      "new": "當前競猜",
      "hist": "歸檔競猜",
      "join": "參與的競猜",
    },
    betOnTrans: "投注",
    betStakeTrans: "已投注",
    betPotentialCollectTrans: "估計收益",
    minimumBetTrans: "投注下限",
    myTokenBalanceTrans: "可用代幣",
    allinTrans: "全下",
    betEndTrans: "已截止",
    voteTypeMultiple: "多選",
    voteTypeSingle: "單選",
    voteLimit: "最多投@項",
    userVoted: "人投票",
    resultAfterVote: "投票後顯示結果",
    vote: "投票",
    voteLimitAlert: "請選擇至少一個選項，且選擇的選項數不要超過此投票的限制",
    voteAttriTypesTrans: {
      "new": "最新投票",
      "hot": "熱門投票",
      "all": "全部投票",
      "me": "發起的投票",
      "join": "參與的投票",
      "list": "用户發起的投票",
    },
    copy: "複製",
    delete: "刪除",
    deleting: "正在刪除",
    deleteSuccess: "刪除成功",
    deleteFailed: "刪除失敗",
    edit: "編輯",
    hiddenByVotedown: "因為反感的用戶過多，此條回复被掩藏。",
    letmeseesee: "讓我看看!",
    emoji: "表情",
    color: "顏色",
    close: "關閉",
    preview: "預覽",
    profilePageName: "用戶資料",
    profileLife: "生命力",
    profilePostCount: "文章",
    profileScore: "積分",
    profileLevel: "等級",
    profileState: "狀態",
    profileOnline: "在線",
    profileOffline: "離線",
    profileStarSign: "星座",
    profileHomePage: "主頁",
    profileQQ: "QQ",
    titleKeywords: "標題關鍵詞",
    authorId: "作者ID",
    timeRage: "時間範圍",
    unlimited: "不限",
    oneWeek: "一周內",
    oneMonth: "一個月內",
    oneYear: "一年內",
    attach: "附件",
    withAttach: "有附件",
    withoutAttach: "無附件",
    searchNoResults: "未能找到符合條件的文章",
    searchHintPart1: "已為您找到",
    searchHintPart2: "個相關結果",
    loadIDLE: "上拉加載",
    loadFailed: "加載失敗，請重試!",
    loadCan: "鬆手加載更多!",
    noMoreData: "沒有更多數據了!",
    homePage: '首頁',
    discover: '發現',
    me: '我',
    frontTabSettingsTrans: '首頁標籤設定',
    pullUpToScreenshot: '上拉截圖',
    releaseToScreenshot: '釋放手指以截圖',
    screenshotFailed: '截圖失敗',
    screenshotCaptured: '截圖成功',
    networkExceptionTrans: '網絡異常',
    dataExceptionTrans: '數據異常',
    toptenScreenshotTrans: '十大上拉截圖',
    screenshotPage: "截圖",
    screenshotOverLength: "內容太長可能會截取不全",
    externalBrowser: "系統瀏覽器打開",
    language: "語言",
    networkType: "網絡",
    settings: "設定",
    publicTesting: "公測",
    importThemeNotification: "請在導入同名配色前先移除舊配色",
    refresherSettings: "刷新動畫設定",
    importRefresherNotification: "請在導入同名刷新動畫前先移除舊刷新動畫",
    refresherAdd: "導入刷新動畫",
    downgradeTrans: "降級版本",
  );
}
