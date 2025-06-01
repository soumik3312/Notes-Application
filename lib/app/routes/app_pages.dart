import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/note_form/bindings/note_form_binding.dart';
import '../modules/note_form/views/note_form_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.HOME;

  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.ADD_NOTE,
      page: () => NoteFormView(),
      binding: NoteFormBinding(),
    ),
    GetPage(
      name: AppRoutes.EDIT_NOTE,
      page: () => NoteFormView(),
      binding: NoteFormBinding(),
    ),
  ];
}