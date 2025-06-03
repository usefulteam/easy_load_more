# CHANGELOG

## [2.0.0] - 2025-06-03

### Breaking Changes
- **Increased minimum Flutter SDK version to 3.0.0**: This package now requires Flutter 3.0.0 or higher. Projects using older Flutter versions will need to upgrade to continue using this package.

## 1.1.0

New property:
- `statusTextColor`: Text color of the statuses.

## 1.0.1

Bugfix:
- Fix `This widget has been unmounted, so the State no longer has a context` error.

## 1.0.0

Bugfix:
- Some properties (`idleStatusText`, `loadingStatusText`, `failedStatusText`, `finishedStatusText`) weren't implemented.

New:
- Add new `loadingWidgetStrokeWidth` property

Breaking changes:
- `EasyLoadMoreDefaultOpts` class renamed to `EasyLoadMoreLoadingWidgetDefaultOpts`
- `DefaultLoadMoreView` class renamed to `EasyLoadMoreView`

## 0.1.0

First usable release.
