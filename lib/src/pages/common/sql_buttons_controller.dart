import 'package:flutter/material.dart';

abstract class SqlButtonsController {
  void updateButtomPressed(BuildContext context);
  void createButtomPressed(BuildContext context);
  void deleteButtomPressed(BuildContext context);
  void findButtomPressed(BuildContext context);
  void clearButtomPressed(BuildContext context);
  SqlButtonsController getButtonBarController(BuildContext context);
  void setButtonBarController(SqlButtonsController controller);

}