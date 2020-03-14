import 'package:mobx/mobx.dart';
import 'package:quran_app/baselib/app_services.dart';
import 'package:quran_app/baselib/command.dart';
import 'package:quran_app/baselib/disposable.dart';
import 'package:quran_app/baselib/widgets.dart';
import 'package:quran_app/models/translation_data.dart';
import 'package:quran_app/services/quran_translation_file_provider.dart';
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class QuranSettingsTranslationItemStore implements Disposable {
  var appServices = sl.get<AppServices>();
  var quranTranslationFileProvider = sl.get<QuranTranslationFileProvider>();

  List<Function> disposeFunction = [];

  QuranSettingsTranslationItemStore(
    TranslationData translationData, {
    AppServices appServices,
    QuranTranslationFileProvider quranTranslationFileProvider,
  }) {
    this.translationData = translationData;

    this.appServices = appServices ?? (appServices = this.appServices);
    this.quranTranslationFileProvider = quranTranslationFileProvider ??
        (quranTranslationFileProvider = this.quranTranslationFileProvider);

    checkTranslationFile = RxCommand.createAsyncNoParamNoResult(() async {
      try {
        var exists = await quranTranslationFileProvider.translationFileExists(
          translationData.filename,
        );
        appServices.logger.i('Translation file exists: $exists');
        translationFileExists.add(exists);
      } catch (e) {
        appServices.logger.i(e);
      }
    });

    {
      var dataFile = quranTranslationFileProvider.getDataFileById(
        translationData.id,
      );
      if (dataFile != null) {
        var d = dataFile.onChangeStatus.doOnData((v) {
          onChangeStatus.add(v);
        }).listen(null);
        disposeFunction.add(() {
          d.cancel();
        });
      }
    }

    // {
    //   var d = quranTranslationFileProvider.onReceiveDataFile.where((t) {
    //     return t.id == translationData.id;
    //   }).doOnData((v) {
    //     appServices.logger.i('Received');

    //     downloadState.add(DownloadStatus.succes);
    //   }).handleError((e) {
    //     downloadState.add(DownloadStatus.error);
    //     downloadStatus = e?.toString();
    //   }).listen(null);
    //   disposeFunction.add(() {
    //     d.cancel();
    //   });
    // }

    downloadTranslation = Command.parameter((v) async {
      onChangeStatus.add(
        QueueStatusModel()..queueStatus = QueueStatus.downloading,
      );

      var dataFile = quranTranslationFileProvider.queueDownload(
        DataFile()
          ..id = translationData.id
          ..url = translationData.uri
          ..filename = translationData.filename,
      );
      var queueStatus = await dataFile.onChangeStatus.skip(1).take(1).first;
      onChangeStatus.add(queueStatus);
      checkTranslationFile.execute();
      await checkTranslationFile.next;
    });
  }

  TranslationData translationData;

  RxCommand checkTranslationFile;

  final translationFileExists = BehaviorSubject<bool>.seeded(false);

  Command<QuranSettingsTranslationItemStore> downloadTranslation;

  var onChangeStatus = BehaviorSubject<QueueStatusModel>.seeded(
    QueueStatusModel()..queueStatus = QueueStatus.notDownloaded,
  );

  bool operator ==(o) =>
      o is QuranSettingsTranslationItemStore &&
      o.translationData == translationData;

  @override
  int get hashCode => translationData.hashCode;

  @override
  void dispose() {
    disposeFunction.forEach((v) {
      v();
    });
  }
}
