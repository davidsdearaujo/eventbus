class Event<T> {
  final T data;
  final DateTime createdAt;
  Event(this.data) : createdAt = DateTime.now();
}
