import 'package:ekskul/constant/color.dart';
import 'package:ekskul/models/ekstra.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/auth_provider_class.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/services.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsEkstra extends StatefulWidget {
  final Ekstrakurikuler ex;
  const DetailsEkstra({Key? key, required this.ex}) : super(key: key);

  @override
  State<DetailsEkstra> createState() => _DetailsEkstraState();
}

class _DetailsEkstraState extends State<DetailsEkstra> {
  User? user;
  var _selectedData = 0;
  Widget anggota(Ekstrakurikuler ex) {
    return ex.id.toString() != user!.id.toString()
        ? const Center(
            child: Text(
              'Anda bukan user dari ekstra ini',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: user!.ekstra.peserta.length,
            itemBuilder: (context, index) {
              var data = user!.ekstra.peserta[index];
              return ListTile(
                title: Text(data.nama),
                dense: true,
                subtitle: Text(data.kelas + data.jurusan),
              );
            },
          );
  }

  Widget image(Ekstrakurikuler ex) {
    return ex.id.toString() != user!.id.toString()
        ? const Center(
            child: Text(
              'Anda bukan user dari ekstra ini',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            itemCount: user!.ekstra.dokumentasi.length,
            itemBuilder: (context, index) {
              var data = user!.ekstra.dokumentasi[index];
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(data.tanggal.toString()),
                      Image.network(Api.urlImage + user!.image)
                    ],
                  ),
                ),
              );
            },
          );
  }

  List<Widget> body = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProviderClass>(context).user;
    body.addAll([anggota(widget.ex), image(widget.ex)]);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.ex;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // print(innerBoxIsScrolled);
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.width * 0.5,
                floating: false,
                pinned: true,
                centerTitle: true,
                title: Text(
                  data.namaEkstrakurikuler,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: primary,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    // StretchMode.blurBackground,

                    StretchMode.fadeTitle, StretchMode.zoomBackground
                  ],
                  background: Image(
                    image: NetworkImage(Api.urlImage + user!.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverPersistentHeader(
                // floating: false,
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: primary,
                    indicatorColor: primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    unselectedLabelColor: Colors.grey.withOpacity(.6),
                    onTap: (value) {
                      setState(() {
                        _selectedData = value;
                      });
                      print(body[value]);
                    },
                    tabs: const [
                      Tab(icon: Icon(Icons.supervised_user_circle)),
                      Tab(icon: Icon(Icons.collections)),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: body[_selectedData],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
  // @override
  // bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
  //   return maxHeight != oldDelegate.maxHeight ||
  //          minHeight != oldDelegate.minHeight || photo != oldDelegate.photo;
  // }
}
