import 'package:nbassetentry/common/model/option.dart';

class StringSet {
  static const String EMPTY = '';
  static const String COLON = '：';
  static const String SOMETHING_WRONG = '该功能存在错误';
  static const String PERIOD = '。';
  static const String NETWORK_DEFAULT_ERROR = '网络错误';
  static const String NETWORK_NOT_CONNECTED = '网络未连接';
  static const String NETWORK_CONNECT_TIMEOUT = '网络连接超时';
  static const String NETWORK_RECEIVE_TIMEOUT = '网络接收超时';
  static const String NETWORK_STATUS_CODE_ERROR = '异常状态码';
  static const String NETWORK_SERVER_EXCEPTION = '服务端数据异常';
  static const String UNKNOWN_ERROR = '未知错误';
  static const String OPERATION_FAILED = '操作失败';
  static const String OPERATION_CANCELLED = '操作取消';
  static const String LOGIN_EXCEPTION = '登录超时';
  static const String PERMISSION_DENIED = '权限不足';
  static const String IP_EXCEPTION = 'IP 异常，需重新登录';
  static const String DATABASE_CONNECTION_FAILED = '数据库连接失败';
  static const String INSTRUCTION_SUBMISSION_FAILED = '指令提交失败';
  static const String THIRD_PARTY_INTERFACE_FAILED = '第三方接口调用失败';
  static const String DATABASE_SUBMISSION_FAILED = '数据库提交失败';
  static const String WRONG_PARAMETER = '参数错误';
  static const String WRONG_USER_NAME_OR_PASSWORD = '用户名或密码错误';
  static const String WRONG_SECURITY_CODE = '安全码错误';
  static const String CAMERA_ACCESS_DENIED = '照相机权限不足';
  static const String USER_NAME = '用户名';
  static const String IS_NECESSARY = ' *';
  static const String USER_NAME_HINT = '请输入用户名';
  static const String PASSWORD = '密码';
  static const String PASSWORD_HINT = '请输入密码';
  static const String LOGIN = '登录';
  static const String NETWORK_DEMO_NAME = '盛同云演示';
  static const String NETWORK_DEMO_IP = '192.168.50.83';
  static const String NETWORK_DEMO_PORT = '10004';
  static const String HOME_TITLE = '小帮手';
  static const String HOME_HINT = '一站式服务解决所有问题';
  static const String LOGIN_OUT = '登出';
  static const String CANCEL = '取 消';
  static const String CONFIRM = '确 定';
  static const String LOGIN_OUT_CONFIRM = '确定要退出登录吗?';
  static const String NB_LAMP = 'NB 单灯';
  static const String SAVE = '保存';
  static const String NB_NAME = '名称/编号';
  static const String NECESSARY = '*';
  static const String NB_GROUP = '所属组';
  static const String NB_OPERATOR = '运营商';
  static const String NB_BARCODE = '条形码';
  static const String NB_IMEI = 'imei';
  static const String NB_IMSI = 'imsi';
  static const String NB_LONGITUDE = '经度';
  static const String NB_LATITUDE = '纬度';
  static const String NB_USED = '投运';
  static const String NB_ALARM = '主动告警';
  static const String NB_REPLY = '主报应答';
  static const String NB_LOOP_COUNT = '灯头数量';
  static const String NB_OPEN_STATUS = '上电开灯';
  static const String NB_PICTURE = '图片';
  static const String NB_HINT = '请输入';
  static const String PLEASE_SELECT = '请选择';
  static const String SPACE = ' ';
  static const String SELECT_ALL = '全选';
  static const String UNSELECT_ALL = '全不选';
  static const String CAMERA = '相机';
  static const String GALLERY = '相册';
  static const NO_SETTING = '不设置';
  static const YES='是';
  static const NO='否';

  static const  String TWENTY = '20W';
  static const String FIFTY = '50W';
  static const String SEVENTY_FIVE = '75W';
  static const String HUNDRED = '100W';
  static const  String HUNDRED_TWENTY = '120W';
  static const String HUNDRED_FIFTY = '150W';
  static const String TWO_HUNDRED = '200W';
  static const String TWO_HUNDRED_FIFTY = '250W';
  static const String THREE_HUNDRED = '300W';
  static const String FOUR_HUNDRED = '400W';
  static const String SIX_HUNDRED = '600W';
  static const String EIGHT_HUNDRED = '800W';
  static const String THOUSAND = '1000W';
  static const String THOUSAND_FIVE_HUNDRED = '1500W';
  static const String TWO_THOUSAND = '2000W';
  static const String IMAGE_GALLERY = '图像查看';
  static const String IOS_AMAP_KEY='7be69f96c1a902abb6dc2287f21a021a';
  static const String LOCATION_PERMISSION='请打开GPS定位权限';
  static const String NETWORK_SETTING='网络设置';
  static const String ADD_NETWORK = '添加网络';
  static const String ADD_NETWORK_SUCCESS = '添加成功';
  static const String EDIT_NETWORK = '修改网络';
  static const String EDIT_NETWORK_SUCCESS = '修改成功';
  static const String CONNECT_NETWORK_SUCCESS = '连接成功';
  static const String DELETE_NETWORK_SUCCESS = '删除成功';
  static const String NO_NETWORKS = '点击右上角加号，添加网络配置';
  static const String EDIT = '编辑';
  static const String DELETE = '删除';
  static const String NETWORK_NAME = '网络名称';
  static const String IP_ADDRESS = 'IP 地址';
  static const String PORT = '端口号';
  static const String PLEASE_INPUT = '请输入';
  static const String CONNECT = '连接';

  /// theme_color
  static const String THEME_COLOR = '主题颜色';
  static const String RED = '红色';
  static const String PINK = '粉红色';
  static const String PURPLE = '紫色';
  static const String DEEP_PURPLE = '深紫色';
  static const String INDIGO = '靛青色';
  static const String BLUE = '蓝色';
  static const String LIGHT_BLUE = '淡蓝色';
  static const String CYAN = '青色';
  static const String TEAL = '水鸭色';
  static const String GREEN = '绿色';
  static const String LIGHT_GREEN = '淡绿色';
  static const String LIME = '酸橙色';
  static const String YELLOW = '黄色';
  static const String AMBER = '琥珀色';
  static const String ORANGE = '橙色';
  static const String DEEP_ORANGE = '深橙色';
  static List<String>summonName=[
    NB_NAME,
    NB_OPERATOR,
    NB_BARCODE,
    NB_IMEI,
    NB_IMSI,
    NB_LONGITUDE,
    NB_LATITUDE,
    NB_USED,
    NB_ALARM,
    NB_REPLY,
    NB_LOOP_COUNT,
  ];

  static List<Option> powerOptions = [
    Option(id: 0, title: NO_SETTING, isChecked: false, value: 0),
    Option(id: 1, title: TWENTY, isChecked: false, value: 20),
    Option(id: 2, title: FIFTY, isChecked: false, value: 50),
    Option(id: 3, title: SEVENTY_FIVE, isChecked: false, value: 75),
    Option(id: 4, title: HUNDRED, isChecked: false, value: 100),
    Option(id: 5, title: HUNDRED_TWENTY, isChecked: false, value: 120),
    Option(id: 6, title: HUNDRED_FIFTY, isChecked: false, value: 150),
    Option(id: 7, title: TWO_HUNDRED, isChecked: false, value: 200),
    Option(id: 8, title: TWO_HUNDRED_FIFTY, isChecked: false, value: 250),
    Option(id: 9, title: THREE_HUNDRED, isChecked: false, value: 300),
    Option(id: 10, title: FOUR_HUNDRED, isChecked: false, value: 400),
    Option(id: 11, title: SIX_HUNDRED, isChecked: false, value: 600),
    Option(id: 12, title: SIX_HUNDRED, isChecked: false, value: 600),
    Option(id: 13, title: EIGHT_HUNDRED, isChecked: false, value: 800),
    Option(id: 14, title: THOUSAND, isChecked: false, value: 1000),
    Option(id: 15, title: THOUSAND_FIVE_HUNDRED, isChecked: false, value: 1500),
    Option(id: 16, title: TWO_THOUSAND, isChecked: false, value: 2000),
  ];
}
