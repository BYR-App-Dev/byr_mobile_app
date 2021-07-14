typedef void EventCallback(arg);

class EventBus {
  EventBus._internal();
  static EventBus _singleton = EventBus._internal();
  factory EventBus() => _singleton;
  var _emap = Map<Object, List<EventCallback>>();
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= List<EventCallback>();
    _emap[eventName].add(f);
  }

  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

var eventBus = EventBus();
const String UPDATE_MAIN_TAB_SETTING = 'update_main_tab_setting';
const String UPDATE_SIMPLE_HOME_SETTING = 'update_simple_home_setting';
