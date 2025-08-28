import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/home/pageexample/page.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpandablePageView(
            children: [
              const AvailableBalanceTile(),
              const CardsTile(),
              const ContactsTile(),
            ],
          ),
          HideCardsButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
