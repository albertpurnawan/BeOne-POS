# Ruby POS

A cross-platform POS app, integrated with BOS Retail and microservices that support authorization and payments.


## Environment
- Flutter 3.19.0
- Dart 3.3.0

## Run
### Debug
1. On VSCode, choose Run > Run Without Debugging
### Release
1. Run flutter build windows
2. Open the app

## VSCode
### Extensions
- Dart (id: dart-code.dart-code)
- Flutter (id: dart-code.flutter)
- bloc (id: felixangelov.bloc)
- Dart Data Class Generator (id: hzgood.dart-data-class-generator)


### Settings
Set 'Line Length' at 120 (Settings > Extension > Dart > Editor > Line Length)

## Git Convention
### Branch
* `feature` branches: Prefixed with feature/, these branches are used to develop new features.
* `bugfix` branches: Prefixed with bugfix/, these branches are used to make fixes.
* `release` branches: Prefixed with release/, these branches prepare a codebase for new releases.
* `hotfix` branches: Prefixed with hotfix/, these branches address urgent issues in production.

        e.g. feature/down-payment
        

### Commit
* `feat` Commits, that adds or remove a new feature
* `fix` Commits, that fixes a bug
* `refactor` Commits, that rewrite/restructure your code, however does not change any API behaviour
* `perf` Commits are special `refactor` commits, that improve performance
* `style` Commits, that do not affect the meaning (white-space, formatting, missing semi-colons, etc)
* `test` Commits, that add missing tests or correcting existing tests
* `docs` Commits, that affect documentation only
* `build` Commits, that affect build components like build tool, ci pipeline, dependencies, project version, ...
* `ops` Commits, that affect operational components like infrastructure, deployment, backup, recovery, ...
* `chore` Miscellaneous commits e.g. modifying `.gitignore`
        
        e.g. chore: init



#### References
- [Conventional Commit Messages by qoomon on GitHub](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)
- [Best Practices for Naming Git Branches](https://graphite.dev/guides/git-branch-naming-conventions)

