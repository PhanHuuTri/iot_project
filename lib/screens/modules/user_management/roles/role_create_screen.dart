import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../../core/modules/user_management/models/role_model.dart';
import '../../../../widgets/errors/error_message_text.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';
import 'role_detail.dart';

class RoleCreateEditScreen extends StatefulWidget {
  final String? id;
  const RoleCreateEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoleCreateEditScreenState();
}

class _RoleCreateEditScreenState extends State<RoleCreateEditScreen> {
  final _roleBloc = RoleBloc();
  final _roleByIdBloc = RoleBloc();

  @override
  void initState() {
    _roleBloc.getAllModule();
    super.initState();
  }

  @override
  void dispose() {
    _roleBloc.dispose();
    _roleByIdBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    if (widget.id != null) {
      return FutureBuilder(
        future: _roleByIdBloc.fetchDataById(widget.id!),
        builder: (context, AsyncSnapshot<RoleModel> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
          if (snapshot.hasData) {
            return RoleDetail(
              roleBloc: _roleBloc,
              roleModel: snapshot.data,
              route: editRoleRoute,
            );
          } else {
            if (snapshot.hasError) {
              return ErrorMessageText(message: snapshot.error.toString());
            }
            return ErrorMessageText(
              message: ScreenUtil.t(I18nKey.roleNotFound)! + ': ${widget.id}',
            );
          }
        },
      );
    } else {
      return RoleDetail(
        roleBloc: _roleBloc,
        route: createRoleRoute,
      );
    }
  }
}
