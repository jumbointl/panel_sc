import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/pages/client/products/list/client_products_list_controller.dart';
import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_products_list_for_this_user_controller.dart';
class ClientProductsListPage extends StatelessWidget {

  ClientProductsListController controller =
  Get.put(ClientProductsListForThisUserController());

  ClientProductsListPage({super.key});
  double imageHeight = 60;
  double imageWidth = 60;
  double heightTextFieldSearch = 30;
  Color resultColor = Colors.lightBlue;
  Color dropDownColor = Colors.lightGreen;
  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  late double marginsHorizontal;
  late double columnsWidth;
  RxBool isLoading = false.obs;
  int count = 1;

  @override
  Widget build(BuildContext context) {


    isLoading.value = controller.isLoading.value;
    marginsHorizontal = controller.getMarginsForMaximumColumns(context);
    columnsWidth = controller.getMaximumInputFieldWidth(context);


        return Obx(() => DefaultTabController(
              length: controller.categories.length,
              //initialIndex: controller.defaultCategoryIndex,
              child: Scaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(160),

                    child: AppBar(
                      backgroundColor: controller.isDebitTransaction.value ? Memory.COLOR_IS_DEBIT_TRANSACTION
                          : Memory.COLOR_IS_CREDIT_TRANSACTION,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      actions: [controller.buttonReload()],
                      title: Text(controller.clientSociety?.name! ?? ''),
                      flexibleSpace:Container(
                        alignment: Alignment.center,
                        width: columnsWidth,
                        margin: EdgeInsets.only(top: 10),
                        child:  Wrap(
                            direction: Axis.horizontal,
                          
                            children: [
                              _buttonBack(),
                              SizedBox(width: 5,),
                              _textFieldSearch(context),
                              SizedBox(width: 5,),
                              _iconShoppingBag(),
                          
                            ],),

                      ),
                      bottom: controller.isLoading.value ? null : TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          indicatorColor: Memory.BAR_ACTIVE_COLOR,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: List<Widget>.generate(controller.categories.length, (index){
                            return Tab(child: Text(controller.categories[index].name ?? ''),);

                          })),
                      ),
                    ),
                body: SafeArea(
                  child: Container(
                    width: columnsWidth,
                    margin: EdgeInsets.symmetric(horizontal: marginsHorizontal),
                    child: controller.isLoading.value ? CircularProgressIndicator() : TabBarView(children: controller.categories.map((Category category){
                      return FutureBuilder(
                          future: _getProducts(context, category),
                          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return  ListView.builder(
                                      itemCount: snapshot.data?.length ?? 0,
                                      itemBuilder: (_, index) {
                                        Product product = snapshot.data![index];
                                        if (category.id == product.idCategory) {
                                          return _cardProduct(context, product,controller.categories.indexOf(category));
                                        } else {
                                          return SizedBox.shrink(); // Return an empty widget if the category doesn't match
                                        }
                                      }
                                  );
                              }
                              else {
                                return NoDataWidget(text: Messages.NO_DATA_FOUND);
                              }
                            }
                            else {
                              return NoDataWidget(text: Messages.NO_DATA_FOUND);
                            }
                          }
                      );
                      }).toList(),
                    ),
                  ),
                )
          )),

    );
  }

  Widget _textFieldSearch(BuildContext context){
    return Container(

        width: controller.getMaximumInputFieldWidth(context)-40,
        height: heightTextFieldSearch ,
        margin: EdgeInsets.only(top: 10),
        child: TextField(

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: Messages.FIND_BY_NAME,
            suffixIcon: Icon(Icons.search,color: Colors.black,),
            hintStyle: TextStyle(fontSize: 17),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey),

            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black),

            ),
            contentPadding: EdgeInsets.all(15),
          ),
        ),
    );

  }
  Widget _cardProduct(BuildContext context, Product product, int indexOf) {

    return GestureDetector(
      //onTap: () => controller.openBottomSheet(context, products),
      onTap: () => controller.goToProductDetailPage(product),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text(product.name ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    product.description ?? '',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${currencyFormatter.format(product.price)}(${controller.tipForPrice})',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              trailing: SizedBox(
                height: imageHeight,
                width: imageWidth,
                // padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FadeInImage(
                    image: product.image1 != null
                        ? NetworkImage(product.image1!)
                        : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
                  ),
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[300], indent: 37, endIndent: 37,)
        ],
      ),
    );
  }
  Widget _buttonBack(){
    return IconButton(

        onPressed: controller.returnToPreviousPage,
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: heightTextFieldSearch,),
    );
  }
  Widget _iconShoppingBag(){
    return IconButton(onPressed: () {
                  controller.goToOrderCreatePage();},
            icon: Icon(Icons.shopping_bag,
              color: controller.items.value > 0 ? Colors.redAccent : Colors.white,
              size: heightTextFieldSearch,),
    );

  }


  Future<List<Product>> _getProducts(BuildContext context, Category category) async {
    List<Product> list = [];
    for(int i=0; i<controller.productsList.length;i++){
      if(controller.productsList[i].idCategory == category.id!){
        list.add(controller.productsList[i]);
      }
    }
    return list;
  }



}
