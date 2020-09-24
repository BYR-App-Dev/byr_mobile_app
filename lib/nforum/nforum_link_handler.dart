import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NForumLinkHandler {
  static bool byrLinkHandler(String url) {
    if (url == null) {
      return false;
    }
    var thread = NForumTextParser.threadPattern.firstMatch(url);
    if (thread != null && int.tryParse(thread.group(2)) != null) {
      navigator.pushNamed("thread_page", arguments: ThreadPageRouteArg(thread.group(1), int.tryParse(thread.group(2))));
      return true;
    }
    var board = NForumTextParser.boardPattern.firstMatch(url);
    if (board != null) {
      navigator.pushNamed("board_page", arguments: BoardPageRouteArg(board.group(1)));
      return true;
    }
    var bet = NForumTextParser.betPattern.firstMatch(url);
    if (bet != null && int.tryParse(bet.group(1)) != null) {
      navigator.pushNamed("bet_page", arguments: BetPageRouteArg(int.tryParse(bet.group(1))));
      return true;
    }
    var vote = NForumTextParser.votePattern.firstMatch(url);
    if (vote != null && int.tryParse(vote.group(1)) != null) {
      navigator.pushNamed("vote_page", arguments: VotePageRouteArg(int.tryParse(vote.group(1))));
      return true;
    }
    return false;
  }

  static bool webLinkHandler(String url) {
    canLaunch(url).then((r) {
      launch(url);
    });
    return true;
  }
}
