import 'dart:async';

import 'package:flutter/material.dart';

typedef FutureCallBack = Future<bool> Function();

enum EasyLoadMoreStatusState {
  idle,
  loading,
  failed,
  finished,
}

class _BuildNotification extends Notification {}

class _RetryNotification extends Notification {}

class EasyLoadMoreDefaultOpts {
  static const double size = 24.0;
  static const double containerHeight = 60.0;
  static const int delay = 16;
  static const Color color = Colors.blue;
}

class EasyLoadMoreStatusText {
  static const String idle = 'Scroll to load more';
  static const String loading = 'Loading...';
  static const String failed = 'Failed to load items';
  static const String finished = 'No more items';

  static String getText(EasyLoadMoreStatusState state) {
    switch (state) {
      case EasyLoadMoreStatusState.idle:
        return idle;
      case EasyLoadMoreStatusState.loading:
        return loading;
      case EasyLoadMoreStatusState.failed:
        return failed;
      case EasyLoadMoreStatusState.finished:
        return finished;
      default:
        return idle;
    }
  }
}

class EasyLoadMore extends StatefulWidget {
  /// The loading widget color.
  final Color loadingWidgetColor;

  /// The dimension's size of the loading widget.
  final double loadingWidgetSize;

  /// The height of the loading widget's container/wrapper.
  final double loadingWidgetContainerHeight;

  /// The loading animation delay.
  final int loadingAnimationDelay;

  /// Status text to show when the load more is not triggered.
  final String idleStatusText;

  /// Status text to show when the process is loading.
  final String loadingStatusText;

  /// Status text to show when the processing is failed.
  final String failedStatusText;

  /// Status text to show when there's no more items to load.
  final String finishedStatusText;

  /// Manually turn-off the next load more.
  ///
  /// Set this to `true` to set the load more as `finished` (no more items). Default is `false`.
  ///
  /// The use-case is when there's no more items to load, you might want `EasyLoadMore` to not running again.
  final bool isFinished;

  /// Whether or not to run the load more even though the result is empty/finished.
  final bool runOnEmptyResult;

  /// Callback function to run during the load more process.
  ///
  /// To mark the status as success or delay, set the return to `true`.
  ///
  /// To mark the status as failed, set the return to `false`.
  final FutureCallBack onLoadMore;

  /// The child widget.
  ///
  /// Supported widgets: `ListView`, `ListView.builder`, & `ListView.separated`.
  final Widget child;

  const EasyLoadMore({
    Key? key,
    this.loadingWidgetColor = EasyLoadMoreDefaultOpts.color,
    this.loadingWidgetSize = EasyLoadMoreDefaultOpts.size,
    this.loadingWidgetContainerHeight = EasyLoadMoreDefaultOpts.containerHeight,
    this.loadingAnimationDelay = EasyLoadMoreDefaultOpts.delay,
    this.idleStatusText = EasyLoadMoreStatusText.idle,
    this.loadingStatusText = EasyLoadMoreStatusText.loading,
    this.failedStatusText = EasyLoadMoreStatusText.failed,
    this.finishedStatusText = EasyLoadMoreStatusText.finished,
    this.isFinished = false,
    this.runOnEmptyResult = false,
    required this.onLoadMore,
    required this.child,
  }) : super(key: key);

  @override
  State<EasyLoadMore> createState() => _EasyLoadMoreState();
}

class _EasyLoadMoreState extends State<EasyLoadMore> {
  Widget get child => widget.child;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (child is ListView) {
      return _buildListView(child as ListView) ?? Container();
    }

    if (child is SliverList) {
      return _buildSliverList(child as SliverList);
    }

    return child;
  }

  Widget? _buildListView(ListView listView) {
    var delegate = listView.childrenDelegate;

    outer:
    if (delegate is SliverChildBuilderDelegate) {
      SliverChildBuilderDelegate delegate =
          listView.childrenDelegate as SliverChildBuilderDelegate;

      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      int viewCount = (delegate.estimatedChildCount ?? 0) + 1;

      builder(context, index) {
        if (index == viewCount - 1) {
          return _buildLoadMoreView();
        }

        return delegate.builder(context, index) ?? Container();
      }

      return ListView.builder(
        itemBuilder: builder,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        itemCount: viewCount,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
      );
    } else if (delegate is SliverChildListDelegate) {
      SliverChildListDelegate delegate =
          listView.childrenDelegate as SliverChildListDelegate;

      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      delegate.children.add(_buildLoadMoreView());

      return ListView(
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        children: delegate.children,
      );
    }

    return listView;
  }

  Widget _buildSliverList(SliverList list) {
    final delegate = list.delegate;

    if (delegate is SliverChildListDelegate) {
      return SliverList(
        delegate: delegate,
      );
    }

    outer:
    if (delegate is SliverChildBuilderDelegate) {
      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      final viewCount = (delegate.estimatedChildCount ?? 0) + 1;

      builder(context, index) {
        if (index == viewCount - 1) {
          return _buildLoadMoreView();
        }

        return delegate.builder(context, index) ?? Container();
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          builder,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          childCount: viewCount,
          semanticIndexCallback: delegate.semanticIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
        ),
      );
    }

    outer:
    if (delegate is SliverChildListDelegate) {
      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      delegate.children.add(_buildLoadMoreView());

      return SliverList(
        delegate: SliverChildListDelegate(
          delegate.children,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          semanticIndexCallback: delegate.semanticIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
        ),
      );
    }

    return list;
  }

  EasyLoadMoreStatusState status = EasyLoadMoreStatusState.idle;

  Widget _buildLoadMoreView() {
    if (widget.isFinished == true) {
      status = EasyLoadMoreStatusState.finished;
    } else {
      if (status == EasyLoadMoreStatusState.finished) {
        status = EasyLoadMoreStatusState.idle;
      }
    }
    return NotificationListener<_RetryNotification>(
      onNotification: _onRetry,
      child: NotificationListener<_BuildNotification>(
        onNotification: _onLoadMoreBuild,
        child: DefaultLoadMoreView(
          status: status,
          color: widget.loadingWidgetColor,
          size: widget.loadingWidgetSize,
          containerHeight: widget.loadingWidgetContainerHeight,
          delay: widget.loadingAnimationDelay,
        ),
      ),
    );
  }

  bool _onLoadMoreBuild(_BuildNotification notification) {
    if (status == EasyLoadMoreStatusState.idle) {
      loadMore();
    }

    if (status == EasyLoadMoreStatusState.loading) {
      return false;
    }

    if (status == EasyLoadMoreStatusState.failed) {
      return false;
    }

    if (status == EasyLoadMoreStatusState.finished) {
      return false;
    }

    return false;
  }

  void _updateStatus(EasyLoadMoreStatusState status) {
    if (mounted) setState(() => this.status = status);
  }

  bool _onRetry(_RetryNotification notification) {
    loadMore();
    return false;
  }

  void loadMore() {
    _updateStatus(EasyLoadMoreStatusState.loading);

    widget.onLoadMore().then((v) {
      if (v == true) {
        // 成功，切换状态为空闲
        _updateStatus(EasyLoadMoreStatusState.idle);
      } else {
        // 失败，切换状态为失败
        _updateStatus(EasyLoadMoreStatusState.failed);
      }
    });
  }
}

class DefaultLoadMoreView extends StatefulWidget {
  final EasyLoadMoreStatusState status;
  final Color color;
  final double size;
  final double containerHeight;
  final int delay;

  const DefaultLoadMoreView({
    Key? key,
    this.status = EasyLoadMoreStatusState.idle,
    this.color = EasyLoadMoreDefaultOpts.color,
    this.size = EasyLoadMoreDefaultOpts.size,
    this.containerHeight = EasyLoadMoreDefaultOpts.containerHeight,
    this.delay = EasyLoadMoreDefaultOpts.delay,
  }) : super(key: key);

  @override
  State<DefaultLoadMoreView> createState() => _DefaultLoadMoreViewState();
}

class _DefaultLoadMoreViewState extends State<DefaultLoadMoreView> {
  final buildNotification = _BuildNotification();
  final retryNotification = _RetryNotification();

  @override
  Widget build(BuildContext context) {
    notify();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.status == EasyLoadMoreStatusState.failed ||
            widget.status == EasyLoadMoreStatusState.idle) {
          _notifyRetryProcess();
        }
      },
      child: Container(
        height: widget.containerHeight,
        alignment: Alignment.center,
        child: buildTextWidget(widget.status),
      ),
    );
  }

  Widget buildTextWidget(EasyLoadMoreStatusState state) {
    String text = EasyLoadMoreStatusText.getText(state);

    if (state == EasyLoadMoreStatusState.failed) {
      return Container(
        padding: const EdgeInsets.all(0.0),
        child: Text(text),
      );
    }

    if (state == EasyLoadMoreStatusState.idle) {
      return Text(text);
    }

    if (state == EasyLoadMoreStatusState.loading) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(text),
            ),
          ],
        ),
      );
    }

    if (state == EasyLoadMoreStatusState.finished) {
      return Text(text);
    }

    return Text(text);
  }

  void notify() async {
    Duration delay = max(
      Duration(
        microseconds: widget.delay,
      ),
      const Duration(
        milliseconds: EasyLoadMoreDefaultOpts.delay,
      ),
    );

    await Future.delayed(delay);

    if (widget.status == EasyLoadMoreStatusState.idle) {
      _notifyBuildProcess();
    }
  }

  Duration max(
    Duration duration,
    Duration duration2,
  ) {
    if (duration > duration2) {
      return duration;
    }
    return duration2;
  }

  void _notifyBuildProcess() {
    buildNotification.dispatch(context);
  }

  void _notifyRetryProcess() {
    retryNotification.dispatch(context);
  }
}
