import 'package:rxdart/rxdart.dart';
import 'package:quiver/core.dart';

class TranslationData {
  String id;

  String filename;

  String languageCode;

  String name;

  String translator;

  final _isSelected$ = BehaviorSubject<bool>(
    sync: true,
  );
  BehaviorSubject<bool> get isSelected$ => _isSelected$;

  bool operator ==(o) =>
      o is TranslationData &&
      id == o.id &&
      name == o.name &&
      filename == o.filename;

  @override
  int get hashCode => hash2(filename, name);
}
