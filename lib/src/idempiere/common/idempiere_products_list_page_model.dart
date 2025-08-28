import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_product.dart';
import '../../models/idempiere/idempiere_product_category.dart';
import '../../widgets/no_data_widget.dart';
class IdempiereProductsListPageModel extends StatelessWidget{


  IdempiereProductsListPageModel({super.key});
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

  get tipForPrice => '';

  @override
  Widget build(BuildContext context) {


    isLoading = getIsLoadingObs();
    marginsHorizontal = getMarginsForMaximumColumns(context);
    columnsWidth = getMaximumInputFieldWidth(context);


        return Obx(() => DefaultTabController(
              length: getCategories().length,
              //initialIndex: controller.defaultIdempiereProductCategoryIndex,
              child: Scaffold(
                appBar: PreferredSize(preferredSize: Size.fromHeight(160),

                    child: AppBar(
                      backgroundColor: getAppBarColor(context) ,
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      actions: getActionButton(),
                      title: Text(getTitle()),
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
                      bottom: isLoading.value ? null : TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          indicatorColor: Memory.BAR_ACTIVE_COLOR,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: List<Widget>.generate(getCategories().length, (index){
                            return Tab(child: Text(getCategories()[index].identifier ?? ''),);

                          })),
                      ),
                    ),
                body: SafeArea(
                  child: Container(
                    width: columnsWidth,
                    margin: EdgeInsets.symmetric(horizontal: marginsHorizontal),
                    child: isLoading.value ? CircularProgressIndicator() : TabBarView(children: getCategories().map((IdempiereProductCategory category){
                      return FutureBuilder(
                          future: getProducts(context, category),
                          builder: (context, AsyncSnapshot<List<IdempiereProduct>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isNotEmpty) {
                                return  ListView.builder(
                                      itemCount: snapshot.data?.length ?? 0,
                                      itemBuilder: (_, index) {
                                        IdempiereProduct idempiereProduct = snapshot.data![index];

                                        if (category.id == Memory.ALL_CATEGORIES_ID || category.id == idempiereProduct.mProductCategoryID?.id) {
                                          return _cardIdempiereProduct(context, idempiereProduct,getCategories().indexOf(category));
                                        } else {
                                          return SizedBox.shrink(); // Return an empty widget if the idempiereProductCategory doesn't match
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

        width: getMaximumInputFieldWidth(context)-40,
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
  Widget _cardIdempiereProduct(BuildContext context, IdempiereProduct idempiereProduct, int indexOf) {
    print('------------------------------------------uid: ${ idempiereProduct.uid ?? 'UID'}');
    return GestureDetector(
      //onTap: () => controller.openBottomSheet(context, idempiereProducts),
      onTap: () => goToIdempiereProductDetailPage(idempiereProduct),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text('SKU: ${idempiereProduct.sKU ?? 'SKU--'} - UPC: ${idempiereProduct.uPC ?? 'UPC--'}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    idempiereProduct.uid ?? 'UID',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  Text(
                    idempiereProduct.mAttributeSetInstanceID?.identifier ?? '',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  Text(
                    idempiereProduct.mProductCategoryID?.identifier ?? '',
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 13
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${currencyFormatter.format(idempiereProduct.price ?? 0)}($tipForPrice)',
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
                    image: idempiereProduct.image1 != null
                        ? NetworkImage(idempiereProduct.image1!)
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

        onPressed: () {buttonBackPressed();},
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: heightTextFieldSearch,),
    );
  }
  Widget _iconShoppingBag(){
    return IconButton(onPressed: () {
                  buttonShoppingBagPressed();},
            icon: Icon(Icons.shopping_bag,
              color: getItemsValue() > 0 ? Colors.redAccent : Colors.white,
              size: heightTextFieldSearch,),
    );

  }
  Future<List<IdempiereProduct>> getProducts(BuildContext context, IdempiereProductCategory category) async {
    return [];
  }



  RxBool getIsLoadingObs() {
    return false.obs;
  }

  double getMarginsForMaximumColumns(BuildContext context) {
    return 20;
  }

  double getMaximumInputFieldWidth(BuildContext context) {
    return MediaQuery.of(context).size.width*0.7;
  }

  List<IdempiereProductCategory> getCategories() {
    return <IdempiereProductCategory>[];
  }

  String getTitle() { return '';}

  Widget getBottomActionButton() {
    return Container();
  }

  Widget getAppBarTitle() {

    return Text('');
  }

  Color getAppBarColor(BuildContext context) {
    return Colors.cyan[300]!;
  }

  List<Widget> getActionButton() {
    return <Widget>[];
  }

  void goToIdempiereProductDetailPage(IdempiereProduct idempiereProduct) {

  }

  void buttonBackPressed() {

  }
  void buttonShoppingBagPressed() {

  }

  int getItemsValue() {
    return 0;
  }

}
