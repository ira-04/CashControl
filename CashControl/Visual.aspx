<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Visual.aspx.cs" Inherits="PersonalFinanceManager.Visual" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Expense and Income Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    
    <form id="form1" runat="server">
        <div style="display: flex; justify-content: space-between;">
            <div style="width: 500px; height: 500px;">
                <h2>Expense and Income Chart by Category</h2>
                <canvas id="categoryChart" class="chart-field"></canvas>
            </div>
            <div style="width: 500px; height: 500px;">
                <h2>Expense V/S Income</h2>
                <canvas id="incomeExpenseChart" class="chart-field"></canvas>
            </div>
        </div>
    </form>

    <script>
        window.onload = function () {
            // Pie Chart
            var ctx1 = document.getElementById('categoryChart').getContext('2d');
            var categoryChart = new Chart(ctx1, {
                type: 'pie', // You can change this to 'bar', 'line', etc.
                data: {
                    labels: chartData.labels,
                    datasets: [{
                        label: 'Amount',
                        data: chartData.data,
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40']
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

            // Income vs Expense Chart
            var ctx2 = document.getElementById('incomeExpenseChart').getContext('2d');
            var incomeExpenseChart = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: ['Income', 'Expense'],
                    datasets: [{
                        label: 'Amount',
                        data: [incomeExpenseData.income, incomeExpenseData.expense], // Use the fetched income and expense data
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
