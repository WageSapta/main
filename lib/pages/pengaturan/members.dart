import 'package:ekskul/constant/color.dart';
import 'package:ekskul/globaldata/global.dart';
import 'package:ekskul/main.dart';
import 'package:ekskul/models/user.dart';
import 'package:ekskul/provider/auth_provider_class.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserProviderClass>(context).user;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, addMember());
        },
        backgroundColor: primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text("Members ${data!.ekstra.namaEkstra}"),
        centerTitle: true,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: data.ekstra.peserta.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {},
            title: Text(
              data.ekstra.peserta[index].nama.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${data.ekstra.peserta[index].kelas} ${data.ekstra.peserta[index].jurusan}',
            ),
            leading: Icon(
              Icons.person,
              color: blue,
            ),
          );
        },
      ),
    );
  }
}

class addMember extends StatefulWidget {
  const addMember({Key? key}) : super(key: key);

  @override
  State<addMember> createState() => _addMemberState();
}

class _addMemberState extends State<addMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
