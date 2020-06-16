import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'base_page.dart';
import 'login_page.dart';
import '../common/config/config.dart';
import '../common/dao/setting_dao.dart';
import '../common/local/network_storage.dart';
import '../common/model/network.dart';
import '../common/style/style_set.dart';
import '../common/style/string_set.dart';
import '../widget/custom_editable_text_cell.dart';

class NetworkEditPage extends StatelessWidget {
  static final String routeName = '/network_edit';
  final Network network;
  final int index;

  bool get isAdd => index == null;

  NetworkEditPage({
    Key key,
    this.network,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      hasAppBar: true,
      color: ThemeDataSet.tabColor,
      title: isAdd ? StringSet.ADD_NETWORK : StringSet.EDIT_NETWORK,
      leadingIconData: Icons.arrow_back_ios,
      leadingOnTap: () => Navigator.pop(context),
      body: NetworkEditWidget(index: index, network: network),
    );
  }
}

class NetworkEditWidget extends StatefulWidget {
  final Network network;
  final int index;

  bool get isAdd => index == null;

  NetworkEditWidget({
    Key key,
    this.network,
    this.index,
  }) : super(key: key);

  @override
  _NetworkEditWidgetState createState() => _NetworkEditWidgetState();
}

class _NetworkEditWidgetState extends State<NetworkEditWidget> {
  Network _network = Network.empty();
  bool _connectIsEnabled = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (widget.index != null) {
      _network = widget.network;
      List<Network> networks = await NetworkStorage.getNetworks();
      _network = networks[widget.index];
      _checkStates();
    }
  }

  void _checkStates() {
    NetworkStorage.getNetworks().then((networks) {
      List<Network> networkList = widget.isAdd
          ? networks
          : networks
              .where((network) => networks.indexOf(network) != widget.index)
              .toList();
      _connectIsEnabled = _network.ip.isNotEmpty &&
          _network.port.isNotEmpty &&
          !networkList.any((network) => network.address == _network.address);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return CustomEditableTextCell(
                        title: StringSet.NETWORK_NAME,
                        content: _network.name,
                        onClear: () {
                          _network.name = StringSet.EMPTY;
                          _checkStates();
                        },
                        onChanged: (value) {
                          _network.name = value;
                          _checkStates();
                        },
                      );
                      break;
                    case 1:
                      return CustomEditableTextCell(
                        title: StringSet.IP_ADDRESS,
                        isNecessary: true,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        content: _network.ip,
                        onClear: () {
                          _network.ip = StringSet.EMPTY;
                          _checkStates();
                        },
                        onChanged: (value) {
                          _network.ip = value;
                          _checkStates();
                        },
                      );
                      break;
                    case 2:
                      return CustomEditableTextCell(
                        title: StringSet.PORT,
                        isNecessary: true,
                        keyboardType: TextInputType.number,
                        content: _network.port,
                        onClear: () {
                          _network.port = StringSet.EMPTY;
                          _checkStates();
                        },
                        onChanged: (value) {
                          _network.port = value;
                          _checkStates();
                        },
                      );
                      break;
                    default:
                      return null;
                  }
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                highlightColor: Theme.of(context).highlightColor,
                disabledColor: Theme.of(context).disabledColor,
                child: Text(
                  StringSet.CONNECT,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: _connectIsEnabled
                    ? () {
                        if (Config.DEBUG) {
                          print(_network.debugDescription);
                        }
                        _connect();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connect() async {
    DaoResult result = await SettingDao.connect(_network);
    if (result == null || !result.isSuccess) {
      return;
    }
    Fluttertoast.showToast(
        msg: (widget.isAdd
                ? StringSet.ADD_NETWORK_SUCCESS
                : StringSet.EDIT_NETWORK_SUCCESS) +
            StringSet.PERIOD);
    List<Network> networks = await NetworkStorage.getNetworks();
    networks.forEach((network) => network.isChecked = false);
    Network newNetwork = Network(
      name: _network.name,
      ip: _network.ip,
      port: _network.port,
      isChecked: true,
    );
    widget.isAdd
        ? networks.add(newNetwork)
        : networks[widget.index] = newNetwork;
    await NetworkStorage.updateNetworks(networks);
    Future.delayed(Duration(milliseconds: 1500)).then((_) {
      if (mounted) {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(LoginPage.routeName));
      }
    });
  }
}
