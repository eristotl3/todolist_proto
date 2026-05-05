import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todolist_proto/features/auth/domain/user_profile.dart';
import 'package:todolist_proto/features/auth/presentation/providers/auth_provider.dart';
import 'package:todolist_proto/features/student/data/student_repository.dart';
import 'package:todolist_proto/features/student/domain/student_item_state.dart';
import 'package:todolist_proto/features/student/presentation/providers/student_completion_provider.dart';
import 'package:todolist_proto/features/teacher/domain/todo_item_model.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

final _testProfile = UserProfile(
  id: 'student-1',
  email: 'alice@test.com',
  fullName: 'Alice',
  role: UserRole.student,
  createdAt: DateTime(2024),
);

final _item = TodoItemModel(
  id: 'item-1',
  listId: 'list-1',
  title: 'Task A',
  position: 0,
  createdAt: DateTime(2024),
);

void main() {
  late MockStudentRepository mockRepo;

  setUp(() {
    mockRepo = MockStudentRepository();
  });

  /// Creates a container with mocked auth (signed-in student) and repo.
  /// Subscribes to [studentCompletionNotifierProvider] so auto-dispose
  /// doesn't fire during the test.
  Future<(ProviderContainer, ProviderSubscription<AsyncValue<List<StudentItemState>>>)>
      makeContainer(List<StudentItemState> initialItems) async {
    when(() => mockRepo.getItemsWithCompletion('list-1', 'student-1'))
        .thenAnswer((_) async => initialItems);

    final container = ProviderContainer(
      overrides: [
        studentRepositoryProvider.overrideWithValue(mockRepo),
        authNotifierProvider
            .overrideWith(() => _FakeAuthNotifier(_testProfile)),
      ],
    );

    // Subscribing keeps the auto-dispose provider alive for the test lifetime
    final sub = container.listen(
      studentCompletionNotifierProvider('list-1'),
      (prev, next) {},
      fireImmediately: true,
    );

    // Wait for initial load
    await container.read(studentCompletionNotifierProvider('list-1').future);

    return (container, sub);
  }

  group('StudentCompletionNotifier.toggle', () {
    test('optimistically flips isCompleted before server resolves', () async {
      final initialState = [StudentItemState(item: _item, isCompleted: false)];

      // Server call takes a little while
      final completer = Future<void>.delayed(const Duration(milliseconds: 50));
      when(() => mockRepo.completeItem('item-1', 'student-1'))
          .thenAnswer((_) => completer);

      final (container, sub) = await makeContainer(initialState);
      addTearDown(() {
        sub.close();
        container.dispose();
      });

      // Fire-and-forget: do NOT await so we can inspect optimistic state
      unawaited(container
          .read(studentCompletionNotifierProvider('list-1').notifier)
          .toggle('item-1'));

      final midState = container
          .read(studentCompletionNotifierProvider('list-1'))
          .valueOrNull;
      expect(midState?.first.isCompleted, isTrue,
          reason: 'optimistic flip should have happened synchronously');

      await completer;
    });

    test('reverts to original state when server throws', () async {
      final initialState = [StudentItemState(item: _item, isCompleted: false)];

      when(() => mockRepo.completeItem('item-1', 'student-1'))
          .thenThrow(Exception('network error'));

      final (container, sub) = await makeContainer(initialState);
      addTearDown(() {
        sub.close();
        container.dispose();
      });

      await container
          .read(studentCompletionNotifierProvider('list-1').notifier)
          .toggle('item-1');

      final afterState = container
          .read(studentCompletionNotifierProvider('list-1'))
          .valueOrNull;
      expect(afterState?.first.isCompleted, isFalse,
          reason: 'should revert on error');
    });

    test('calls uncompleteItem when item was already completed', () async {
      final initialState = [StudentItemState(item: _item, isCompleted: true)];

      when(() => mockRepo.uncompleteItem('item-1', 'student-1'))
          .thenAnswer((_) async {});

      final (container, sub) = await makeContainer(initialState);
      addTearDown(() {
        sub.close();
        container.dispose();
      });

      await container
          .read(studentCompletionNotifierProvider('list-1').notifier)
          .toggle('item-1');

      verify(() => mockRepo.uncompleteItem('item-1', 'student-1')).called(1);
      verifyNever(() => mockRepo.completeItem(any(), any()));
    });

    test('calls completeItem when item was not completed', () async {
      final initialState = [StudentItemState(item: _item, isCompleted: false)];

      when(() => mockRepo.completeItem('item-1', 'student-1'))
          .thenAnswer((_) async {});

      final (container, sub) = await makeContainer(initialState);
      addTearDown(() {
        sub.close();
        container.dispose();
      });

      await container
          .read(studentCompletionNotifierProvider('list-1').notifier)
          .toggle('item-1');

      verify(() => mockRepo.completeItem('item-1', 'student-1')).called(1);
      verifyNever(() => mockRepo.uncompleteItem(any(), any()));
    });
  });
}

/// Fake AuthNotifier that immediately returns a signed-in profile.
class _FakeAuthNotifier extends AuthNotifier {
  final UserProfile _profile;
  _FakeAuthNotifier(this._profile);

  @override
  Future<UserProfile?> build() async => _profile;
}

// Dart 3 helper — suppress "unawaited future" lint without ignoring the whole block
void unawaited(Future<void> f) {}
