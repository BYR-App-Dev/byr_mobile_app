import 'package:byr_mobile_app/nforum/nforum_structures.dart';
import 'package:byr_mobile_app/pages/pageable_list_base_page.dart';

class ArticleListBaseData<X extends ArticleListBaseModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

abstract class ArticleListBasePage extends PageableListBasePage {}

/// need to override initialization, buildCell, buildSeparator, build
abstract class ArticleListBasePageState<Y extends ArticleListBaseModel, Z extends ArticleListBasePage>
    extends PageableListBasePageState<Y, Z> {}

class UserListData<X extends UserListModel> extends PageableListBaseData<X> {
  X articleList;
  PageableListDataRequestHandler<X> dataRequestHandler;
}

abstract class UserListPage extends PageableListBasePage {}

/// need to override initialization, buildCell, buildSeparator, build
abstract class UserListPageState<Y extends UserListModel, Z extends UserListPage>
    extends PageableListBasePageState<Y, Z> {}
