// sync simpan tanggal sampai date

// netzme status: waiting ketika createInvoice & paid sudah dibayar
// ketika withdraw paid harus diganti


            final tcurr = await GetIt.instance<ItemMasterApi>()
          .fetchData(topos[0].lastSync ?? lastSyncDate);

      final tcurrDb =
          await GetIt.instance<AppDatabase>().itemMasterDao.readAll();

      if (tcurrDb.isNotEmpty) {
        final tcurrDbMap = {for (var datum in tcurrDb) datum.docId: datum};

        for (final datumBos in tcurr) {
          final datumDb = tcurrDbMap[datumBos.docId];

          if (datumDb != null) {
            if (datumBos.form == "U" &&
                (datumBos.updateDate?.isAfter(DateTime.parse(lastSyncDate)) ??
                    false)) {
              await GetIt.instance<AppDatabase>()
                  .itemMasterDao
                  .update(docId: datumDb.docId, data: datumBos);
            }
          } else {
            await GetIt.instance<AppDatabase>()
                .itemMasterDao
                .create(data: datumBos);
          }
        }
      } else {
        final allData = await GetIt.instance<ItemMasterApi>()
            .fetchData("2000-01-01 00:00:00");
        await GetIt.instance<AppDatabase>()
            .itemMasterDao
            .bulkCreate(data: allData);
      }


// need update topos store name after sync data