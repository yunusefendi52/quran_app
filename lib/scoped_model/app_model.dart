import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:queries/collections.dart';

class QuranScreenScopedModel extends Model {
  QuranDataService _quranDataService;

  QuranDataModel quranDataModel = QuranDataModel();
  ChaptersModel chaptersModel = ChaptersModel();

  IEnumerable<Sura> get listSura => quranDataModel?.quran?.sura;

  IEnumerable<Sura> get listSuraOnly => listSura?.select(
        (v) => Sura(
              index: v.index,
              name: v.name,
            ),
      );

  QuranScreenScopedModel() {
    _quranDataService = QuranDataService.instance;
  }

  Future init() async {
    quranDataModel = await _quranDataService.getQuranDataModel();
    chaptersModel = await _quranDataService.getChapters();
    notifyListeners();
  }
}
