import 'storable.dart';

abstract class KimikoModel implements KimikoStorable {
  final String id;

  const KimikoModel({required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is KimikoModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
