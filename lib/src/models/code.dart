/// Http responses state and message data model
class Code {
  final bool state;
  final String message;
  const Code(this.message, this.state);

  @override
  toString() => 'Code{state: $state, message: $message}';
}
