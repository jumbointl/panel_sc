
import '../../data/messages.dart';
import '../../models/default_selection.dart';

class DefaultSelectionDropdown {
  static List<DefaultSelection> list =[DefaultSelection(defaultSelection: 1, name: Messages.DEFAULT_SELECTION)
    ,DefaultSelection(defaultSelection: 0, name: Messages.NOT_DEFAULT_SELECTION),];

  static DefaultSelection noDefaultSelectionItem = DefaultSelection(defaultSelection: 0, name: Messages.NOT_DEFAULT_SELECTION);
  static DefaultSelection defaultSelectionItem = DefaultSelection(defaultSelection: 1, name: Messages.DEFAULT_SELECTION);

}