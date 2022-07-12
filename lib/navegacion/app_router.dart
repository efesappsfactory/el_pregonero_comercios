import 'package:flutter/material.dart';

import '../modelos/modelos.dart';
import '../vistas/vistas.dart';
import 'app_link.dart';

class AppRouter extends RouterDelegate<AppLink>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final PromocionManager promocionManager;
  final PerfilManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.promocionManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    promocionManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    promocionManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) ...[
          SplashVista.page(),
        ] else if (!appStateManager.isLoggedIn) ...[
          LoginVista.page(),
        ] else if (!appStateManager.isOnboardingComplete) ...[
          OnboardingVista.page(),
        ] else ...[
          Inicio.page(appStateManager.getSelectedTab),
          if (promocionManager.isCreatingNewItem)
            PromocionItemVista.page(onCreate: (item) {
              promocionManager.addItem(item);
            }, onUpdate: (item, index) {
              // No update
            }),
          if (promocionManager.selectedIndex != -1)
            PromocionItemVista.page(
                item: promocionManager.selectedGroceryItem,
                index: promocionManager.selectedIndex,
                onCreate: (_) {
                  // No create
                },
                onUpdate: (item, index) {
                  promocionManager.updateItem(item, index);
                }),
          if (profileManager.didSelectUser)
            PerfilVista.page(profileManager.getUser),
        ]
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == ElPregoneroPaginas.onboardingPath) {
      appStateManager.logout();
    }

    if (route.settings.name == ElPregoneroPaginas.groceryItemDetails) {
      promocionManager.groceryItemTapped(-1);
    }

    if (route.settings.name == ElPregoneroPaginas.profilePath) {
      profileManager.tapOnProfile(false);
    }

    if (route.settings.name == ElPregoneroPaginas.raywenderlich) {
      profileManager.tapOnRaywenderlich(false);
    }

    return true;
  }

  AppLink getCurrentPath() {
    // 1
    if (!appStateManager.isLoggedIn) {
      return AppLink(location: AppLink.kLoginPath);
      // 2
    } else if (!appStateManager.isOnboardingComplete) {
      return AppLink(location: AppLink.kOnboardingPath);
      // 3
    } else if (profileManager.didSelectUser) {
      return AppLink(location: AppLink.kProfilePath);
      // 4
    } else if (promocionManager.isCreatingNewItem) {
      return AppLink(location: AppLink.kItemPath);
      // 5
    } else if (promocionManager.selectedGroceryItem != null) {
      final id = promocionManager.selectedGroceryItem?.id;
      return AppLink(location: AppLink.kItemPath, itemId: id);
      // 6
    } else {
      return AppLink(
          location: AppLink.kHomePath,
          currentTab: appStateManager.getSelectedTab);
    }
  }

  @override
  AppLink get currentConfiguration => getCurrentPath();

  // 1
  @override
  Future<void> setNewRoutePath(AppLink newLink) async {
    // 2
    switch (newLink.location) {
      // 3
      case AppLink.kProfilePath:
        profileManager.tapOnProfile(true);
        break;
      // 4
      case AppLink.kItemPath:
        // 5
        final itemId = newLink.itemId;
        if (itemId != null) {
          promocionManager.setSelectedGroceryItem(itemId);
        } else {
          // 6
          promocionManager.createNewItem();
        }
        // 7
        profileManager.tapOnProfile(false);
        break;
      // 8
      case AppLink.kHomePath:
        // 9
        appStateManager.goToTab(newLink.currentTab ?? 0);
        // 10
        profileManager.tapOnProfile(false);
        promocionManager.groceryItemTapped(-1);
        break;
      // 11
      default:
        break;
    }
  }
}
