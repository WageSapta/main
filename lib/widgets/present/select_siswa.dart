import 'package:ekskul/constant/color.dart';
import 'package:ekskul/models/user.dart';
import 'package:flutter/material.dart';

class SelectSiswa extends StatefulWidget {
  final int index;
  final bool selected;
  final Peserta siswa;
  final VoidCallback onTap;

  const SelectSiswa({
    Key? key,
    required this.index,
    required this.selected,
    required this.siswa,
    required this.onTap,
  }) : super(key: key);

  @override
  SelectSiswaState createState() => SelectSiswaState();
}

class SelectSiswaState extends State<SelectSiswa> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var data = widget.siswa;
    var index = widget.index;
    return Card(
      color: widget.selected == true ? primary.withOpacity(.5) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: grey.withOpacity(.2),
                    radius: 18,
                    child: Text(
                      (++index).toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    data.nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "${data.kelas} ${data.jurusan}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
