import 'package:nbassetentry/common/model/option.dart';

class StringSet {
  static const String EMPTY = '';
  static const String COLON = '：';
  static const String SLASH='/';
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
  static const String NETWORK_DEMO_IP = '112.13.203.162';
 // static const String NETWORK_DEMO_IP = '10.3.8.52';
  static const String NETWORK_DEMO_PORT = '15508';
  static const String HOME_TITLE = '小帮手';
  static const String HOME_HINT = '一站式服务解决所有问题';
  static const String LOGIN_OUT = '登出';
  static const String CANCEL = '取 消';
  static const String CONFIRM = '确 定';
  static const String LOGIN_OUT_CONFIRM = '确定要退出登录吗?';
  static const String NB_LAMP = 'NB 单灯';
  static const String SAVE = '保存';
  static const String ROAD_NAME='道路名称';
  static const String LAMP_CODE='灯杆编号';
  static const String NB_NAME = '名称/编号';
  static const String NECESSARY = '*';
  static const String NB_GROUP = '所属组';
  static const String NB_OPERATOR = '运营商';
  static const String NB_BARCODE = '条形码';
  static const String NB_IMEI = 'imei';
  static const String NB_IMSI = 'imsi';
  static const String NB_LONGITUDE = '经度';
  static const String NB_LATITUDE = '纬度';
  static const String NB_ICCID='iccid';
  static const String NB_CYCLE='主报周期（分钟）';
  static const String NB_VERSION='版本协议';
  static const String NB_PROVIDER='厂家区分标志位';
  static const String NB_USED = '投运';
  static const String NB_ALARM = '是否主报';
  static const String NB_REPLY = '主报应答';
  static const String NB_LOOP_COUNT = '灯头数量';
  static const String NB_OPEN_STATUS = '上电开灯';
  static const String NB_REVERSE='反向调光';
  static const String NB_PICTURE = '图片';
  static const String NB_HINT = '请输入';
  static const String PLEASE_SELECT = '请选择';
  static const String SPACE = ' ';
  static const String SELECT_ALL = '全选';
  static const String UNSELECT_ALL = '全不选';
  static const String CAMERA = '相机';
  static const String GALLERY = '相册';
  static const NO_SETTING = '不设置';
  static const String YES='是';
  static const String NO='否';
  static const String OPEN='(开灯)';
  static const String CLOSE='(关灯)';
  static const String LOOP='回路';
  static const String RATED_POWER='额定功率';

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
  static const String NB_RESET_SUCCESS='复位成功';
  static const String NB_SEND_OVERTIME='下发参数操作，设备响应超时！';
  static const String NB_READ_OVERTIME='召测参数操作，设备响应超时！';
  static const String NB_DIMMING_OVERTIME='调光操作，设备响应超时！';
  static const String NB_REST_OVERTIME='复位操作，设备响应超时！';

  static const String NB_REPORT_SUCCESS='资产录入成功';
  static const String NB_UPDATE_SUCCESS='资产更新成功';
  static const String NB_ISSUED_SUCCESS='下发参数成功';

  static const String ZERO='0';
  static const String DOUBLE_ZERO='0.0';
  static const String JPUSH_KEY = '46d90f1665a2adc1a31f6a62';

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
    NB_ICCID,
    NB_USED,
    NB_ALARM,
    NB_REPLY,
    NB_LOOP_COUNT,
  ];

  static List<Option>versionOptions=[
    Option(id: 0, title: 'v0.1', isChecked: false),
    Option(id: 1, title: 'v0.2', isChecked: false),
  ];

  static List<Option> powerOptions = [
    Option(id: 0, title: NO_SETTING, isChecked: false),
    Option(id: 20, title: TWENTY, isChecked: false),
    Option(id: 50, title: FIFTY, isChecked: false),
    Option(id: 75, title: SEVENTY_FIVE, isChecked: false),
    Option(id: 100, title: HUNDRED, isChecked: false),
    Option(id: 120, title: HUNDRED_TWENTY, isChecked: false),
    Option(id: 150, title: HUNDRED_FIFTY, isChecked: false),
    Option(id: 200, title: TWO_HUNDRED, isChecked: false),
    Option(id: 250, title: TWO_HUNDRED_FIFTY, isChecked: false),
    Option(id: 300, title: THREE_HUNDRED, isChecked: false),
    Option(id: 400, title: FOUR_HUNDRED, isChecked: false),
    Option(id: 600, title: SIX_HUNDRED, isChecked: false),
    Option(id: 800, title: EIGHT_HUNDRED, isChecked: false),
    Option(id: 1000, title: THOUSAND, isChecked: false),
    Option(id: 1500, title: THOUSAND_FIVE_HUNDRED, isChecked: false),
    Option(id: 2000, title: TWO_THOUSAND, isChecked: false),
  ];
}
