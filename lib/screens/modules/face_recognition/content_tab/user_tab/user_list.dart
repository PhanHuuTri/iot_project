import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/blocs/face_user/face_user_bloc.dart';
import '../../../../../core/base/blocs/block_state.dart';
import '../../../../../core/modules/face_recog/models/face_user_model.dart';
import '../../../../../main.dart';
import '../../../../../widgets/data_table/table_component.dart';
import '../../../../../widgets/data_table/table_pagination.dart';
import '../../../../../widgets/debouncer/debouncer.dart';
import '../../../../../widgets/joytech_components/joytech_components.dart';
import '../../../../../widgets/table/dynamic_table.dart';
import 'edit_user_role.dart';

final faceUserKey = GlobalKey<_UserRecListState>();

class UserRecList extends StatefulWidget {
  final Function(int) changeTab;
  final TextEditingController keyword;
  const UserRecList({
    Key? key,
    required this.changeTab,
    required this.keyword,
  }) : super(key: key);

  @override
  _UserRecListState createState() => _UserRecListState();
}

class _UserRecListState extends State<UserRecList> {
  late Debouncer _debouncer;
  List<String> selected = [];
  final _faceUserBloc = FaceUserBloc();
  final _faceRecoRoleBloc = FaceUserBloc();
  // ignore: prefer_final_fields
  int _limit = 10;
  // ignore: prefer_final_fields
  List<String> roleSource = [];

  @override
  void initState() {
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _faceUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchField(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTable(),
          ),
        ],
      );
    });
  }

  Widget _buildSearchField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 437,
          child: JTSearchField(
            controller: widget.keyword,
            hintText: ScreenUtil.t(I18nKey.searchNameAndEmail)!,
            onPressed: () {
              setState(
                () {
                  if (widget.keyword.text.isEmpty) return;
                  widget.keyword.text = '';
                  _fetchDataOnPage(1);
                },
              );
            },
            onChanged: (newValue) {
              _debouncer.debounce(afterDuration: () {
                _fetchDataOnPage(1);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.faceRecoUser)!,
        width: 150,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.email)!,
        width: 150,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.roleGroup)!,
        width: 250,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.action)!,
        width: 100,
        isConstant: true,
      ),
    ];
    return Stack(
      children: [
        StreamBuilder(
          stream: _faceUserBloc.allData,
          builder: (context,
              AsyncSnapshot<ApiResponse<FaceUserListModel?>> snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!.model!.records;
              final int _total = int.tryParse(snapshot.data!.model!.total)!;
              return StreamBuilder(
                  stream: _faceRecoRoleBloc.allRole,
                  builder: (
                    context,
                    AsyncSnapshot<ApiResponse<ListFaceFaceRoleModel?>>
                        roleSnapshot,
                  ) {
                    if (roleSnapshot.hasData) {
                      final roles = roleSnapshot.data!.model!.records;
                      roleSource = roles.map((e) => e.name).toList();
                    }
                    int _totalPage = (_total / _limit).ceil();
                    final Paging meta = Paging.fromJson(
                      {
                        "total_records": _total,
                        "limit": _limit,
                        "page": faceUserTabIndex,
                        "total_page": _totalPage,
                      },
                    );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DynamicTable(
                          columnWidthRatio: tableHeaders,
                          numberOfRows: users.length,
                          rowBuilder: (index) => _rowFor(
                            item: users[index],
                            roleSnapshot: roleSnapshot,
                          ),
                          hasBodyData: true,
                          tableBorder:
                              Border.all(color: AppColor.black, width: 1),
                          headerBorder: TableBorder(
                            bottom: const BorderSide(color: AppColor.black),
                            verticalInside: BorderSide(
                              color: AppColor.noticeBackground,
                            ),
                          ),
                          headerStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          bodyBorder: TableBorder.all(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        TablePagination(
                          onFetch: _fetchDataOnPage,
                          pagination: meta,
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: snapshot.error.toString().trim() == 'request timeout'
                    ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                    : Text(snapshot.error.toString()),
              );
            }
            return const SizedBox();
          },
        ),
        StreamBuilder(
          stream: _faceUserBloc.allDataState,
          builder: (context, state) {
            if (!state.hasData || state.data == BlocState.fetching) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: JTCircularProgressIndicator(
                    size: 24,
                    strokeWidth: 2.0,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  TableRow _rowFor({
    required FaceUserModel item,
    required AsyncSnapshot<ApiResponse<ListFaceFaceRoleModel?>> roleSnapshot,
  }) {
    return TableRow(
      children: [
        tableCellText(title: item.name),
        tableCellText(title: item.email.isNotEmpty ? item.email : ''),
        tableCellText(
          title:
              item.accessGroups.isNotEmpty ? item.accessGroups.first.name : '',
        ),
        tableCellText(
          child: InkWell(
            child: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
            onTap: () {
              if (roleSnapshot.hasData) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return EditUserRoles(
                        faceUserModel: item,
                        faceRoles: roleSnapshot.data!.model!.records,
                        faceUserBloc: _faceUserBloc,
                        onFetch: () {
                          _fetchDataOnPage(1);
                        },
                      );
                    });
              }
            },
          ),
        ),
      ],
    );
  }

  _fetchDataOnPage(int page) {
    faceUserTabIndex = page;
    faceUserSearchString = widget.keyword.text;

    Map<String, dynamic> params = {
      'limit': _limit,
      'page': faceUserTabIndex,
    };
    if (faceUserSearchString.isNotEmpty) {
      params['search_string'] = faceUserSearchString;
    }
    _faceUserBloc.fetchAllData(params: params);
  }

  fetchData() {
    _faceUserBloc.fetchAllData(params: {
      'limit': _limit,
      'page': faceUserTabIndex,
    });
    _faceRecoRoleBloc.fetchAllRoles();
  }
}
