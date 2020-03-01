import 'package:rxdart/rxdart.dart';

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
}
