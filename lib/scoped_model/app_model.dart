import 'package:quran_app/models/chapters_models.dart';
import 'package:quran_app/models/juz_model.dart';
import 'package:quran_app/models/quran_data_model.dart';
import 'package:quran_app/services/quran_data_services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:queries/collections.dart';

class QuranScreenScopedModel extends Model {
  QuranDataService _quranDataService;

  QuranDataModel quranDataModel = QuranDataModel();
  ChaptersModel chaptersModel = ChaptersModel();

  List<Sura> get listSura => quranDataModel?.quran?.sura;

  List<Sura> get listSuraOnly => listSura?.map(
        (v) => Sura(
              index: v.index,
              name: v.name,
            ),
      );

  QuranScreenScopedModel() {
    _quranDataService = QuranDataService.instance;
  }

  bool isGettingChapters = true;

  // Future init() async {
  //   quranDataModel = await _quranDataService.getQuranDataModel();
  //   chaptersModel = await _quranDataService.getChapters();
  //   notifyListeners();
  // }

  Future getChapters() async {
    try {
      isGettingChapters = true;

      chaptersModel = await _quranDataService.getChapters();
      notifyListeners();
    } finally {
      isGettingChapters = false;
      notifyListeners();
    }
  }
}

class QuranJuzScreenScopedModel extends Model {
  QuranDataService _quranDataService = QuranDataService.instance;
  bool isGettingJuzs = true;

  JuzModel juzModel;

  ChaptersModel chaptersModel;

  Future getJuzs() async {
    try {
      isGettingJuzs = true;

      juzModel = await _quranDataService.getJuzs();
      notifyListeners();
    } finally {
      isGettingJuzs = false;
      notifyListeners();
    }
  }

  Future getChapters() async {
    chaptersModel = await _quranDataService.getChapters();
  }
}
