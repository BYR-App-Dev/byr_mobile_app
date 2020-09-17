import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/dropdown_menu.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/reusable_components/vote_bet_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VoteListingCell extends StatelessWidget {
  final VoteModel vote;
  VoteListingCell(this.vote);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: E().threadListBackgroundColor.withOpacity(0.12),
      onTap: () {},
      child: NonPaddingListTile(
        contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0),
        onTap: () {
          if (int.tryParse(vote.vid) != null) {
            Navigator.pushNamed(context, "vote_page", arguments: VotePageRouteArg(int.tryParse(vote.vid)));
          }
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              vote.title,
              style: TextStyle(
                fontSize: 17.0,
                color: E().threadListTileTitleColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: 10,
              top: 5,
              bottom: 10,
            ),
            child: Text(
              DateTime.fromMillisecondsSinceEpoch(int.tryParse(vote.end) * 1000)
                  .toString()
                  .replaceAll(RegExp(r'....$'), ''),
              style: TextStyle(fontSize: 12.0, color: E().threadListOtherTextColor),
              overflow: TextOverflow.fade,
            ),
          ),
        ]),
      ),
    );
  }
}

class VoteListBaseData<X extends VoteListModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

class VoteListPage extends PageableListBasePage {
  @override
  VoteListPageState createState() => VoteListPageState();
}

class VoteListPageState extends PageableListBasePageState<VoteListModel, VoteListPage>
    with SingleTickerProviderStateMixin, InitializationFailureViewMixin {
  VoteAttrType leftValue = VoteAttrType.attr_new;

  void onValueChangeLeft(VoteAttrType newValue) {
    leftValue = newValue;
    initialization();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initialization() {
    data = VoteListBaseData<VoteListModel>()
      ..dataRequestHandler = (int page) {
        return NForumService.getVoteList(leftValue);
      };
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    return VoteListingCell(data.articleList.article[index]);
  }

  @override
  Widget buildSeparator(BuildContext context, int index, {bool isLast = false}) {
    return Container(
      height: 4.0,
      margin: EdgeInsetsDirectional.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: E().threadListDividerColor, width: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        backgroundColor: E().threadListBackgroundColor,
        body: Column(
          children: [
            DropdownMenu(
              onItemSelected: (index) {
                onValueChangeLeft(VoteAttrType.values[index]);
              },
              backgroundColor: E().voteBetListBackgroundColor,
              itemLength: VoteAttrType.values.length - 1,
              itemBuilder: (index, isSelected) {
                return VoteBetDropDownItem(
                  ("voteAttriTypesTrans" +
                          GetUtils.capitalizeFirst(NForumTextParser.getStrippedEnumValue(VoteAttrType.values[index])))
                      .tr,
                  isSelected,
                );
              },
              headerBuilder: (isShowing) {
                return VoteBetDropDownHeader(
                  ("voteAttriTypesTrans" + GetUtils.capitalizeFirst(NForumTextParser.getStrippedEnumValue(leftValue)))
                      .tr,
                  isShowing,
                );
              },
            ),
            Expanded(
              child: widgetCase(
                initializationStatus,
                {
                  InitializationStatus.Initializing: _buildLoadingView(),
                  InitializationStatus.Failed: InitializationFailureView(
                    failureInfo: failureInfo,
                    textColor: E().threadListOtherTextColor,
                    buttonColor: E().threadListOtherTextColor,
                    refresh: initialization,
                  ),
                  InitializationStatus.Initialized: data.articleList == null
                      ? _buildLoadingView()
                      : RefresherFactory(
                          factor,
                          refreshController,
                          true,
                          true,
                          onTopRefresh,
                          onBottomRefresh,
                          buildList(),
                        ),
                },
                _buildLoadingView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: !E().isThemeDarkStyle ? Colors.grey[300] : Colors.grey,
      highlightColor: !E().isThemeDarkStyle ? Colors.grey[100] : Colors.white,
      enabled: true,
      child: ListView.separated(
        itemCount: 20,
        padding: const EdgeInsets.all(0),
        separatorBuilder: (context, i) {
          return Container(
            height: 0.0,
            margin: EdgeInsetsDirectional.only(start: 0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: E().threadListDividerColor, width: 4),
              ),
            ),
          );
        },
        itemBuilder: (context, i) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 10, top: 8),
                  height: 20,
                  width: (85 / 100) * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
