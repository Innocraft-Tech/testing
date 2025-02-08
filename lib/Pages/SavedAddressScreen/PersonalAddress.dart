import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/SavedAddressScreen/SavedAddressScreenVM.dart';

class PersonalAddress extends StatefulWidget {
  List<AddressBO> addressList;
  PersonalAddress({super.key, required this.addressList});

  @override
  State<PersonalAddress> createState() => _PersonalAddressState();
}

class _PersonalAddressState extends State<PersonalAddress> {
  List<AddressBO> addressList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterAddress();
  }

  void filterAddress() {
    widget.addressList.forEach((element) {
      if (element.addressType == "Personal") {
        addressList.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: Styles.transparent,
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: addressList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  left: ResponsiveUI.w(16, context),
                  right: ResponsiveUI.w(16, context),
                  top: ResponsiveUI.h(16, context)),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Color.fromRGBO(114, 114, 114, 0.39))),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUI.w(10, context),
                        vertical: ResponsiveUI.h(10, context)),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(114, 114, 114, 0.39),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppConstants.addressStartIcon,
                          width: ResponsiveUI.w(24, context),
                          height: ResponsiveUI.h(24, context),
                        ),
                        SizedBox(
                          width: ResponsiveUI.w(27, context),
                        ),
                        Text(
                          addressList[index].addressName,
                          style: TextStyle(
                              fontSize: ResponsiveUI.sp(16, context),
                              fontFamily: "MontserratBold",
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUI.h(10, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: ResponsiveUI.w(237, context),
                          child: Text(
                            addressList[index].address,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(14, context),
                                fontFamily: "MontserratRegualar",
                                color: Color.fromRGBO(255, 255, 255, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUI.w(20, context),
                              vertical: ResponsiveUI.h(10, context)),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(73, 69, 255, 0.23),
                              border: Border.all(
                                  color: Color.fromRGBO(73, 69, 255, 1))),
                          child: Text(
                            "use",
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(14, context),
                                fontFamily: "MontserratBold",
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
