<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Visual.aspx.cs" Inherits="PersonalFinanceManager.Visual" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Expense and Income Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" type="text/css" href="styles.css" />
</head>
<body>
    <div>
    <form id="form1" runat="server">
        <div class="chart-container">
            <div class="chart-section">
                <h2>Income by Category</h2>
                <canvas id="incomeCategoryChart" class="chart-field"></canvas>
            </div>
            <div class="chart-section">
                <h2>Expense by Category</h2>
                <canvas id="expenseCategoryChart" class="chart-field"></canvas>
            </div>
        </div>
        <div class="chart-section">
            <h2>Expense V/S Income</h2>
            <canvas id="incomeExpenseChart" class="chart-field"></canvas>
        </div>
    </form>
    </div>

    <script>
        window.onload = function () {
            // Income Category Pie Chart
            var ctx1 = document.getElementById('incomeCategoryChart').getContext('2d');
            var incomeCategoryChart = new Chart(ctx1, {
                type: 'pie',
                data: {
                    labels: incomeChartData.labels,
                    datasets: [{
                        label: 'Income Amount',
                        data: incomeChartData.data,
                        backgroundColor: ['#4BC0C0', '#36A2EB', '#9966FF', '#FF9F40', '#FF6384', '#FFCE56']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    var total = 0;
                                    var dataArr = tooltipItem.chart.data.datasets[0].data;
                                    dataArr.map(function (item) {
                                        total += item;
                                    });
                                    var value = tooltipItem.raw;
                                    var percentage = ((value / total) * 100).toFixed(2);
                                    return tooltipItem.label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });

            // Expense Category Pie Chart
            var ctx2 = document.getElementById('expenseCategoryChart').getContext('2d');
            var expenseCategoryChart = new Chart(ctx2, {
                type: 'pie',
                data: {
                    labels: expenseChartData.labels,
                    datasets: [{
                        label: 'Expense Amount',
                        data: expenseChartData.data,
                        backgroundColor: ['#FF6384', '#FF9F40', '#9966FF', '#4BC0C0', '#36A2EB', '#FFCE56']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    var total = 0;
                                    var dataArr = tooltipItem.chart.data.datasets[0].data;
                                    dataArr.map(function (item) {
                                        total += item;
                                    });
                                    var value = tooltipItem.raw;
                                    var percentage = ((value / total) * 100).toFixed(2);
                                    return tooltipItem.label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });

            // Income vs Expense Bar Chart
            var ctx3 = document.getElementById('incomeExpenseChart').getContext('2d');
            var incomeExpenseChart = new Chart(ctx3, {
                type: 'bar',
                data: {
                    labels: ['Income', 'Expense'],
                    datasets: [{
                        label: 'Amount',
                        data: [incomeExpenseData.income, incomeExpenseData.expense],
                        backgroundColor: ['#4BC0C0', '#FF6384'],
                        borderColor: ['#36A2EB', '#FFCE56'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        };
    </script>
</body>
</html>

