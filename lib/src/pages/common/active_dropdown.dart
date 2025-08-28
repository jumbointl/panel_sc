import 'package:solexpress_panel_sc/src/models/active.dart';

import '../../data/messages.dart';

class ActiveDropdown {
  static List<Active> activeList =[Active(active: 1, name: Messages.ACTIVE)
    ,Active(active: 0, name: Messages.NOT_ACTIVE),];

  static Active noActiveItem = Active(active: 0, name: Messages.NOT_ACTIVE);
  static Active activeItem = Active(active: 1, name: Messages.ACTIVE);

}