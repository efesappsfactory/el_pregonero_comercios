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
  final PerfilManager perfilManager;

  AppRouter({
    required this.appStateManager,
    required this.promocionManager,
    required this.perfilManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    promocionManager.addListener(notifyListeners);
    perfilManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    promocionManager.removeListener(notifyListeners);
    perfilManager.removeListener(notifyListeners);
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
          Inicio.page(),
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
          if (perfilManager.didSelectUser)
            PerfilVista.page(perfilManager.getUser),
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
      perfilManager.tapOnProfile(false);
    }

    if (route.settings.name == ElPregoneroPaginas.raywenderlich) {
      perfilManager.tapOnRaywenderlich(false);
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
    } else if (perfilManager.didSelectUser) {
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
      return AppLink(location: AppLink.kHomePath);
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
        perfilManager.tapOnProfile(true);
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
        perfilManager.tapOnProfile(false);
        break;
      // 8
      case AppLink.kHomePath:
        perfilManager.tapOnProfile(false);
        promocionManager.groceryItemTapped(-1);
        break;
      // 11
      default:
        break;
    }
  }
}
