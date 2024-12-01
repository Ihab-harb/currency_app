import 'package:flutter/material.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'WorkSans',
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  String selectedInputCurrency = "USD";
  String selectedOutputCurrency = "EUR";
  final TextEditingController inputController = TextEditingController();
  String convertedValue = "0.00";

  // Hardcoded conversion rates
  final Map<String, Map<String, double>> conversionRates = {
    "USD": {"USD": 1.0, "EUR": 0.95, "LBP": 89000.0},
    "EUR": {"USD": 1.06, "EUR": 1.0, "LBP": 94340.0},
    "LBP": {"USD": 0.000011235955056179, "EUR": 0.000010599957600169, "LBP": 1.0},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFB),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Currency Converter",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E161B),
              ),
            ),
            const SizedBox(height: 24),
            _buildInputSection(),
            const SizedBox(height: 24),
            _buildOutputSection(),
            const SizedBox(height: 24),
            _buildConvertButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E161B),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFE8EEF3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter amount",
                  hintStyle: const TextStyle(color: Color(0xFF507A95)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Currency",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E161B),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildCurrencyDropdown(
                  value: selectedInputCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedInputCurrency = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutputSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Converted Value",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E161B),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      convertedValue,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E161B),
                      ),
                    ),
                    Icon(
                      _getCurrencyIcon(selectedOutputCurrency),
                      color: const Color(0xFF0E161B),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Currency",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E161B),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildCurrencyDropdown(
                  value: selectedOutputCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedOutputCurrency = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _performConversion,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B81C5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(48),
        ),
        child: const Text(
          "Convert",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFFF8FAFB),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF507A95)),
      underline: Container(),
      isExpanded: true,
      items: ["USD", "EUR", "LBP"].map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Row(
            children: [
              Icon(
                _getCurrencyIcon(currency),
                size: 18,
                color: const Color(0xFF0E161B),
              ),
              const SizedBox(width: 8),
              Text(
                currency,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0E161B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  IconData _getCurrencyIcon(String currency) {
    switch (currency) {
      case "USD":
        return Icons.attach_money;
      case "EUR":
        return Icons.euro;
      case "LBP":
        return Icons.currency_exchange;
      default:
        return Icons.attach_money;
    }
  }

  void _performConversion() {
    double inputAmount = double.tryParse(inputController.text) ?? 0.0;

    setState(() {
      double rate = conversionRates[selectedInputCurrency]![selectedOutputCurrency] ?? 1.0;
      convertedValue = (inputAmount * rate).toStringAsFixed(2);
    });
  }
}
