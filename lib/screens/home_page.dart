import 'dart:convert';

import 'package:deneme/model/currency.dart';
import 'package:deneme/api/currency_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> currencies = <String>[];
  late bool isLoading;
  String selectedCurrency = " ";
  Currency? currentCurrency;
  CurrencyApi currencyApi = CurrencyApi();

  @override
  void initState() {
    super.initState();
    isLoading = false;

    getCurrenciesFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency API",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: _CurrenciesWidget(),
    );
  }

  _CurrenciesWidget() {
    return Container(
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text("Currencies : "),
            isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    focusColor: Colors.blueGrey,
                    dropdownColor: Colors.white,
                    value: selectedCurrency,
                    items: currencies
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) async {
                      setState(() {
                        selectedCurrency = value.toString();
                      });
                      await getCurrencyFromApi(value.toString());
                    },
                  ),
            SizedBox(height: 30),
            _buildCurrency
          ],
        ),
      ),
    );
  }

  Widget get _buildCurrency => currentCurrency == null
      ? Container()
      : Column(
          children: [
            Text("Base: ${currentCurrency!.base}"),
            SizedBox(height: 10.0),
            Text("Date: ${currentCurrency!.date}"),
            ListView.separated(
                controller: ScrollController(),
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                      leading: Text(currentCurrency!.rates.entries
                          .toList()[index]
                          .key
                          .toString()),
                      trailing: Text(currentCurrency!.rates.entries
                          .toList()[index]
                          .value
                          .toString()),
                    ),
                separatorBuilder: (_, index) => Divider(),
                itemCount: currentCurrency!.rates.entries.length),
          ],
        );

  Future getCurrenciesFromApi() async {
    setState(() {
      isLoading = true;
    });
    currencyApi.getCurrencies().then((result) {
      setState(() {
        (result.data as Map).forEach((key, value) {
          currencies.add(key);
        });
      });
      selectedCurrency = currencies[0];
    });

    setState(() {
      isLoading = false;
    });
  }

  Future getCurrencyFromApi(String currencyCode) async {
    setState(() {
      isLoading = true;
    });
    currencyApi.getCurrency(currencyCode).then((result) {
      setState(() {
        currentCurrency = Currency.fromJson(result.data);
      });
    });
    setState(() {
      isLoading = false;
    });
    return currentCurrency;
  }
}
