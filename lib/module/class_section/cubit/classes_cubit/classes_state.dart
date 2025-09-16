  part of 'classes_cubit.dart';

  enum ClassesStatus {
    none,
    loading,
    success,
    failure,
  }

  class ClassesState {
    final ClassesStatus classesStatus;
    final BaseFailure failure;
    final List<Class> classes;

    ClassesState({
      required this.classesStatus,
      required this.failure,
      required this.classes,
    });

    factory ClassesState.initial() {
      return ClassesState(
        classesStatus: ClassesStatus.none,
        failure: const BaseFailure(),
        classes: [],
      );
    }

    ClassesState copyWith({
      ClassesStatus? classesStatus,
      BaseFailure? failure,
      List<Class>? classes,
    }) {
      return ClassesState(
        classesStatus: classesStatus ?? this.classesStatus,
        failure: failure ?? this.failure,
        classes: classes ?? this.classes,
      );
    }
  }

