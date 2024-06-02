import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../transaction/model/transaction_model.dart';
import '../../../common_widgets/category_icons.dart';

class ExpenseDonutChart extends StatefulWidget {
  final List<Transaction> transactions;

  const ExpenseDonutChart({Key? key, required this.transactions}) : super(key: key);

  @override
  _ExpenseDonutChartState createState() => _ExpenseDonutChartState();
}

class _ExpenseDonutChartState extends State<ExpenseDonutChart> {
  late List<ChartData> data;
  late String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    updateChartData();
  }

  void updateChartData() {
    final expenseByCategory = <String, double>{};

    // Calculate total expenses by category
    for (var transaction in widget.transactions) {
      if (transaction.type == 'Expense') {
        expenseByCategory.update(
          transaction.category!,
              (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }
    }

    data = expenseByCategory.entries.map((entry) {
      return ChartData(category: entry.key, amount: entry.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
      child: Text('No expenses found for this month'),
    )
        : SfCircularChart(
      title: ChartTitle(text: 'Expenses by Category'),
      legend: Legend(isVisible: true),
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.amount,
          pointColorMapper: (ChartData data, _) => categories[data.category]?.color ?? Colors.grey,
          legendIconType: LegendIconType.seriesType,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData({required this.category, required this.amount});
  final String category;
  final double amount;
}

class Category {
  final IconData icon;
  final Color color;

  Category({
    required this.icon,
    required this.color,
  });
}