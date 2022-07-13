# easy_load_more

![GitHub repo size](https://img.shields.io/github/repo-size/usefulteam/easy_load_more.svg)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/usefulteam/easy_load_more.svg)
![GitHub top language](https://img.shields.io/github/languages/top/usefulteam/easy_load_more.svg)
[![GitHub issues](https://img.shields.io/github/issues/usefulteam/easy_load_more.svg)](https://github.com/usefulteam/easy_load_more/issues)
[![GitHub license](https://img.shields.io/github/license/usefulteam/easy_load_more.svg)](https://github.com/usefulteam/easy_load_more/blob/master/LICENSE)

**easy_load_more** is a simple, easy to use, and customizeable load more that supports `ListView` & `SliverList`.

![](https://raw.githubusercontent.com/usefulteam/easy_load_more/main/media/easy-load-more-0.1.0-demo.gif)

Or try the [demo on DartPad](https://dartpad.dev/?id=02e5cf68c51a6e16a79e5c951b488409)

## Get started

### **Depend on it**

Add this to your package's `pubspec.yaml` file:

```yaml
easy_load_more: ^0.1.0
```

### **Install it**

You can install packages from the command line:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get.

### **Import it**

Now in your Dart code, you can use:

```dart
import 'package:easy_load_more/easy_load_more.dart';

```

## How to use

```dart
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.blue[50],
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: EasyLoadMore(
          isFinished: count >= 60,
          onLoadMore: _loadMore,
          runOnEmptyResult: false,
          child: ListView.separated(
            separatorBuilder: ((context, index) => const SizedBox(
                  height: 20.0,
                )),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Text(
                  list[index].toString(),
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            itemCount: count,
          ),
        ),
      ),
    );
  }

  Future<bool> _loadMore() async {
    log("onLoadMore callback run");

    await Future.delayed(
      const Duration(
        seconds: 0,
        milliseconds: 2000,
      ),
    );

    _loadItems();
    return true;
  }

  Future<void> _refresh() async {
    await Future.delayed(
      const Duration(
        seconds: 0,
        milliseconds: 2000,
      ),
    );

    list.clear();
    _loadItems();
  }

  void _loadItems() {
    log("loading items");

    setState(() {
      list.addAll(List.generate(20, (i) => i + 1));
      log("data count = ${list.length}");
      log("----------");
    });
  }
```

More parameters:
```dart
const EasyLoadMore({
  Key? key,

  /// `double` - (Optional) The height of the loading widget's container/wrapper.
  this.loadingWidgetContainerHeight;

  /// `double` - (Optional) The loading widget size.
  this.loadingWidgetSize;

  /// `double` - (Optional) The loading widget stroke width.
  this.loadingWidgetStrokeWidth;

  /// `Color` - (Optional) The loading widget color.
  this.loadingWidgetColor;

  /// `int` - (Optional) The loading widget animation delay.
  this.loadingWidetAnimationDelay;

  /// `string` - (Optional) Idle status text to show when the widget is idle.
  this.idleStatusText,

  /// `string` - (Optional) Loading status text to show when the process is loading.
  this.loadingStatusText,

  /// `string` - (Optional) Loading status text to show when the processing is failed.
  this.failedStatusText,

  /// `string` - (Optional) Finished status text to show when there's no more items to load.
  this.finishedStatusText,

  /// `bool` - (Optional) Manually turn-off the next load more.
  /// Set this to `true` to set the load more as `finished` (no more items). Default is `false`.
  /// The use-case is when there's no more items to load, you might want `EasyLoadMore` to not running again.
  this.isFinished,

  /// `bool` - (Optional) - Whether or not to run the load more even though the result is empty/finished.
  this.runOnEmptyResult,

  /// `Future<bool> Function()` - (Optional) - Callback function to run during the load more process.
  /// To mark the status as success or delay, set the return to `true`.
  /// To mark the status as failed, set the return to `false`.
  this.onLoadMore,

  /// `Widget` - The child widget.
  /// Supported widgets: `ListView`, `ListView.builder`, & `ListView.separated`.
  required this.child,
}) : super(key: key);
```

## Source
Source code and example of this library can be found in git:

```
$ git clone https://github.com/usefulteam/easy_load_more.git
```

## License
[MIT License](https://oss.ninja/mit?organization=Useful%20Team)

## Credits
Thanks to [OpenFlutter](https://github.com/OpenFlutter/) for the [`flutter_listview_loadmore`](https://github.com/OpenFlutter/flutter_listview_loadmore) package (APACHE 2.0 Licensed).

My package was based on it. You can also visit their [package pub.dev](https://pub.dev/packages/loadmore) page.
