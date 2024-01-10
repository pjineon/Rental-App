  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharing_world2/common/widgets/custom_button.dart';
import 'package:sharing_world2/constants/global_variables.dart';
import 'package:sharing_world2/features/address/screens/address_screen.dart';
import 'package:sharing_world2/features/cart/widgets/cart_product.dart';
import 'package:sharing_world2/features/cart/widgets/cart_subtotal.dart';
import 'package:sharing_world2/features/home/widgets/address_box.dart';
import 'package:sharing_world2/features/search/screens/search_screen.dart';
import 'package:sharing_world2/providers/user_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late DateTime startDate = DateTime.now();
  late DateTime endDate = DateTime.now();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddressScreen(
                  totalPrice: 3,
          index: 0
              ),
            ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: '물건 검색',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            CartSubtotal(startDate: startDate, endDate: endDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectStartDate,
                  child: Text(
                    startDate != null
                        ? '시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate!)}'
                        : '시작 날짜 선택',
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectEndDate,
                  child: Text(
                    endDate != null
                        ? '종료 날짜: ${DateFormat('yyyy-MM-dd').format(endDate!)}'
                        : '종료 날짜 선택',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: '구매하기 (${user.cart.length})',
                onTap: () => navigateToAddress(),
                color: Colors.yellow[600],
              )
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedStartDate != null && pickedStartDate != startDate) {
      setState(() {
        startDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedEndDate != null && pickedEndDate != endDate) {
      setState(() {
        endDate = pickedEndDate;
      });
    }
  }
}
