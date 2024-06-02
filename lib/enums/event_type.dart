enum EventType {
  seminar,
  conference,
  practicalLesson,
  exam,
  evaluation,
  laboratory,
  other,
}

extension EventTypeModel on EventType {
  String get asString {
    switch (this) {
      case EventType.seminar:
        return 'Seminario';
      case EventType.conference:
        return 'Conferencia';
      case EventType.practicalLesson:
        return 'Clase Práctica';
      case EventType.exam:
        return 'Prueba Final';
      case EventType.evaluation:
        return 'Evaluación';
      case EventType.laboratory:
        return 'Laboratorio';
      case EventType.other:
        return 'Otro';
    }
  }

  static EventType? fromString(String? string) {
    switch (string) {
      case 'Seminario':
        return EventType.seminar;
      case 'Conferencia':
        return EventType.conference;
      case 'Clase Práctica':
        return EventType.practicalLesson;
      case 'Prueba Final':
        return EventType.exam;
      case 'Evaluación':
        return EventType.evaluation;
      case 'Laboratorio':
        return EventType.laboratory;
      case 'Otro':
        return EventType.other;
      default:
        return null;
    }
  }
}
