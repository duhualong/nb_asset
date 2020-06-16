import 'dart:async';
import 'base_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../common/dao/dao_result.dart';
import '../common/dao/setting_dao.dart';
import '../common/event/network_event.dart';
import '../common/local/network_storage.dart';
import '../common/model/network.dart';
import '../common/style/string_set.dart';
import '../common/style/style_set.dart';
import '../widget/error_handle.dart';
import '../widget/network_setting_cell.dart';

import 'network_edit_page.dart';

class NetworkSettingPage extends StatelessWidget {
  static final String routeName = '/network_setting';

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: true,
      color: ThemeDataSet.tabColor,
      title: StringSet.NETWORK_SETTING,
      leadingIconData: Icons.arrow_back_ios,
      leadingOnTap: () => Navigator.pop(context),
      body:NetWorkSettingWidget() ,
      actions: <Widget>[
        GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(NetworkEditPage.routeName),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class NetWorkSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NetWorkSettingList();
  }
}

class NetWorkSettingList extends StatefulWidget {
  @override
  _NetWorkSettingListState createState() => _NetWorkSettingListState();
}

class _NetWorkSettingListState extends State<NetWorkSettingList> {
  List<Network> _networks = [];
  StreamSubscription _stream;

  @override
  void initState() {
    super.initState();
    _refresh();
    _stream = NetworkEvent.eventBus.on<String>().listen((data) {
      if (data != NetworkEvent.ON_UPDATED) {
        return;
      }
      _refresh();
    });
  }

  Future<void> _refresh() async {
    List<Network> networks = await NetworkStorage.getNetworks();
    _networks = networks;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _networks.isNotEmpty
          ? ListView.builder(
              itemCount: _networks.length,
              itemBuilder: (context, index) => NetworkSettingCell(
                network: _networks[index],
                onTap: () => _connect(index: index),
                onEdit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ErrorHandle(
                        child: NetworkEditPage(
                          network: _networks[index],
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
                onDelete: () => _delete(index: index),
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Text(
                StringSet.NO_NETWORKS + StringSet.PERIOD,
                style: TextStyle(fontSize: 15),
              ),
            ),
    );
  }

  Future<void> _delete({int index}) async {
    List<Network> networks = await NetworkStorage.getNetworks();
    Fluttertoast.showToast(
        msg: StringSet.DELETE_NETWORK_SUCCESS + StringSet.PERIOD);
    networks.removeAt(index);
    await NetworkStorage.updateNetworks(networks);
  }

  Future<void> _connect({int index}) async {
    List<Network> networks = await NetworkStorage.getNetworks();
    DaoResult result = await SettingDao.connect(networks[index]);
    if (result == null || !result.isSuccess) {
      return;
    }
    Fluttertoast.showToast(
        msg: StringSet.CONNECT_NETWORK_SUCCESS + StringSet.PERIOD);
    networks.forEach((network) => network.isChecked = false);
    networks[index].isChecked = true;
    await NetworkStorage.updateNetworks(networks);
    Future.delayed(Duration(milliseconds: 1200)).then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
