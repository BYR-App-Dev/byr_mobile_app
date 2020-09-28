import 'package:byr_mobile_app/customizations/shimmer_theme.dart';
import 'package:byr_mobile_app/customizations/theme_controller.dart';
import 'package:byr_mobile_app/helper/helper.dart';
import 'package:byr_mobile_app/nforum/nforum_service.dart';
import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/nforum/nforum_text_parser.dart';
import 'package:byr_mobile_app/pages/page_components.dart';
import 'package:byr_mobile_app/pages/pageable_list_base_page.dart';
import 'package:byr_mobile_app/pages/pages.dart';
import 'package:byr_mobile_app/reusable_components/dropdown_menu.dart';
import 'package:byr_mobile_app/reusable_components/no_padding_list_tile.dart';
import 'package:byr_mobile_app/reusable_components/page_initialization.dart';
import 'package:byr_mobile_app/reusable_components/refreshers.dart';
import 'package:byr_mobile_app/reusable_components/vote_bet_dropdown_item.dart';
import 'package:flutter/material.dart';

class BetListingCell extends StatelessWidget {
  final BetModel bet;
  BetListingCell(this.bet);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: E().threadListBackgroundColor.withOpacity(0.12),
      splashColor: E().threadListBackgroundColor.withOpacity(0.15),
      onTap: () {},
      child: NonPaddingListTile(
        contentPadding: EdgeInsets.only(left: 16, right: 16, top: 0),
        onTap: () {
          if (int.tryParse(bet.bid) != null) {
            Navigator.pushNamed(context, "bet_page", arguments: BetPageRouteArg(int.tryParse(bet.bid)));
          }
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              bet.title,
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
              bet.end,
              style: TextStyle(fontSize: 12.0, color: E().threadListOtherTextColor),
              overflow: TextOverflow.fade,
            ),
          ),
        ]),
      ),
    );
  }
}

class BetListBaseData<X extends BetListModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

class BetListPage extends PageableListBasePage {
  @override
  BetListPageState createState() => BetListPageState();
}

class BetListPageState extends PageableListBasePageState<BetListModel, BetListPage>
    with SingleTickerProviderStateMixin, InitializationFailureViewMixin {
  BetCategoriesModel cateList;
  BetAttrType leftValue = BetAttrType.attr_new;
  BetCategoryModel rightValue;

  void onValueChangeLeft(BetAttrType newValue) {
    leftValue = newValue;
    initialization();
    if (mounted) {
      setState(() {});
    }
  }

  void onValueChangeRight(BetCategoryModel newValue) {
    rightValue = newValue;
    initialization();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initialization() {
    data = BetListBaseData<BetListModel>()
      ..dataRequestHandler = (int page) {
        return NForumService.getBetList(leftValue, cid: rightValue?.cid);
      };
    (cateList == null ? NForumService.getBetCategory() : Future.sync(() => cateList)).then((cates) {
      cateList = cates;
      if (rightValue == null) {
        rightValue = cateList.category.firstWhere((element) => element.show);
      }
    }).catchError(initializationErrorHandling);
    super.initialization();
  }

  @override
  Widget buildCell(BuildContext context, int index) {
    return BetListingCell(data.articleList.article[index]);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: DropdownMenu(
                    onItemSelected: (index) {
                      onValueChangeLeft(BetAttrType.values[index]);
                    },
                    backgroundColor: E().voteBetListBackgroundColor,
                    itemLength: BetAttrType.values.length,
                    itemBuilder: (index, isSelected) {
                      return VoteBetDropDownItem(
                        ("betAttriTypesTrans" +
                                GetUtils.capitalizeFirst(
                                    NForumTextParser.getStrippedEnumValue(BetAttrType.values[index])))
                            .tr,
                        isSelected,
                      );
                    },
                    headerBuilder: (isShowing) {
                      return VoteBetDropDownHeader(
                        ("betAttriTypesTrans" +
                                GetUtils.capitalizeFirst(NForumTextParser.getStrippedEnumValue(leftValue)))
                            .tr,
                        isShowing,
                      );
                    },
                  ),
                  flex: 1,
                ),
                (cateList == null || cateList.category.length <= 0)
                    ? Container()
                    : Expanded(
                        child: DropdownMenu(
                          onItemSelected: (index) {
                            onValueChangeRight(cateList.category[index]);
                          },
                          backgroundColor: E().voteBetListBackgroundColor,
                          itemLength: cateList.category.length,
                          itemBuilder: (index, isSelected) {
                            return VoteBetDropDownItem(
                              cateList.category[index].name,
                              isSelected,
                            );
                          },
                          headerBuilder: (isShowing) {
                            return VoteBetDropDownHeader(
                              rightValue.name,
                              isShowing,
                            );
                          },
                        ),
                        flex: 1,
                      ),
              ],
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
    return ShimmerTheme(
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
