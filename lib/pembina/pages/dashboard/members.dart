import '../../models/peserta.dart';
import '../../widgets/members/dialog_member.dart';
import '../../../constant/color.dart';
import '../../models/user.dart';
import '../../provider/members_provider_class..dart';
import '../../widgets/members/search_bar.dart';
import '../../provider/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Future? futureGet;
  String idEkstra = "";
  List<Peserta> pesertas = [];
  int length = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Shared.getIdEkstra().then((value) => setState(() => idEkstra = value));
      futureGet = Provider.of<MembersProviderClass>(context, listen: false)
          .getMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembersProviderClass>(
      builder: (context, members, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const SearchAppBar(),
          body: RefreshIndicator(
            color: primary,
            onRefresh: () => members.refreshData(),
            child: FutureBuilder(
              future: futureGet,
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasError) {
                  EasyLoading.showToast('Something is wrong',
                      toastPosition: EasyLoadingToastPosition.bottom);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(color: primary),
                    ),
                  );
                }
                return widgetListView(
                    snapshot: members.members, search: members.searchResult);
              },
            ),
          ),
        );
      },
    );
  }

  widgetListView({required List<Peserta> snapshot, String? search}) {
    List<Peserta> dataSnapshot = [];
    if (search != null || search!.isNotEmpty || search != "") {
      for (var e in snapshot) {
        if (e.nama.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            e.jurusan.toLowerCase().contains(
                  search.toLowerCase(),
                ) ||
            (e.jenisKelamin == "L" ? "Laki Laki" : "Perempuan")
                .toLowerCase()
                .contains(search.toLowerCase()) ||
            e.nis.contains(search)) {
          // print(e.get('nama'));
          dataSnapshot.add(e);
        } else {
          dataSnapshot.remove(e);
        }
      }
    } else {
      dataSnapshot = snapshot;
    }

    return ListView.builder(
      itemCount: dataSnapshot.length,
      itemBuilder: (context, index) {
        var data = dataSnapshot[index];
        return ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => DialogMember(siswa: data),
            );
          },
          key: UniqueKey(),
          // selected: value.selectedPresents.contains(data),
          dense: true,
          leading: CircleAvatar(
            backgroundColor: bone,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(
                fontSize: 14.0,
                color: primary,
              ),
            ),
          ),
          title: Text(
            data.nama,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            data.nis,
            style: const TextStyle(
              fontSize: 13.0,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${data.kelas} ${data.jurusan}",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                data.jenisKelamin == "L" ? "Laki Laki" : "Perempuan",
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
