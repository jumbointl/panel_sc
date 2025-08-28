import 'package:solexpress_panel_sc/src/models/orders_pdf_by_price.dart';

import '../data/memory.dart';
import '../data/messages.dart';
import '../utils/relative_time_util.dart';
import 'order.dart';


class OrdersPdfByProduct extends OrdersPdfByPrice{
  List<String> prices = [];

  OrdersPdfByProduct({
    super.filePath,
    super.orders,
    required super.commission,
    required super.society,

  });

  @override
  void setProductList(){
    for (var order in orders!) {
      if(order.total!=null){
        total = total + order.total!;
      }
      if(order.documentItems!=null){

        for (var product in order.documentItems!) {
          String data = product.name!;
          bool found = false;
          for (var name in products) {
            if(name==data){
              found = true;
              break;
            }
          }
          if(!found){
            products.add(data);
            prices.add(Memory.currencyFormatter.format(product.price));
          }

        }
      }
    }
    for (int i=0;i<products.length;i++) {
      quantities.add(0);

    }
  }
  @override
  List<String> getRowFromOrder(Order order){
    List<String> row = <String>[];
    List<double> q = <double>[];
    for(int i=0;i<products.length;i++){
      q.add(0);
      for (var product in order.documentItems!) {
        String name = product.name!;
        if(product.quantity!=null && name==products[i]){
          quantities[i] = quantities[i] + product.quantity!;
          q[i] = q[i] + product.quantity!;
        }

      }
    }
    row.add(RelativeTimeUtil.getDayMonth(order.deliveredTime));
    if(order.documentItems!=null){
      for(int i=0;i<products.length;i++){
        if(q[i]==0){
          row.add('');
        } else {
          row.add(Memory.numberFormatter.format(q[i]));
        }

      }
    }
    row.add(Memory.numberFormatter.format(order.total));
    return row ;

  }
  @override
  List<String> getTitles(){
    List<String> list = <String>[Messages.DATE];

    for (int i=0;i<products.length;i++) {
      list.add('''${products[i]}\n${prices[i]}''');
    }
    list.add(Messages.SUM);

    return list;
  }

}