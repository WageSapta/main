import '../../widgets/members/form_members.dart';
import '../../../constant/color.dart';
import '../../globalwidget/global.dart';
import '../../provider/members_provider_class..dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    var value = Provider.of<MembersProviderClass>(context);
    return value.isSearch
        ? WillPopScope(
            onWillPop: () {
              value.searchController.clear();
              value.searchResult = "";
              value.isSearch = false;
              return Future.value(false);
            },
            child: AppBar(
              backgroundColor: primary,
              leading: IconButton(
                color: Colors.white,
                onPressed: () {
                  value.searchController.clear();
                  value.isSearch = false;
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: TextFormField(
                controller: value.searchController,
                autofocus: true,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search...',
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 2,
                    minHeight: 2,
                  ),
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  suffixIcon: value.searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () => value.searchController.clear(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (e) {
                  value.searchResult = e;
                },
                cursorColor: white,
              ),
            ),
          )
        : AppBar(
            title: Row(
              children: [
                const Text("Members"),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: bone,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${value.members.length}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              IconButton(
                splashRadius: 20,
                onPressed: () => value.isSearch = true,
                icon: const Icon(Icons.search),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () => push(context, const FormMembers()),
                icon: const Icon(Icons.add),
              ),
            ],
          );
  }
}
