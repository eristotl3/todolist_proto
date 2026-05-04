class RouteNames {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String roleSelection = '/role-selection';

  static const String teacherHome = '/teacher/home';
  static const String classDetail = '/teacher/class/:classId';
  static const String todoList = '/teacher/class/:classId/list/:listId';
  static const String createList = '/teacher/class/:classId/create-list';
  static const String createItem = '/teacher/class/:classId/list/:listId/create-item';
  static const String studentProgress = '/teacher/class/:classId/student/:studentId';

  static const String studentHome = '/student/home';
  static const String joinClass = '/student/join-class';
  static const String studentTodo = '/student/list/:listId';
}
