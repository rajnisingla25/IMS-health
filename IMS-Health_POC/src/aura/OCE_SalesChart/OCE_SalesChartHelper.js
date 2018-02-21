({
    // Get Sales Chart for HCP Profile
    getSalesChart: function(cmp) {
        // Check passed in param to check if line chart is displayed or stacked column chart
        if (cmp.get("v.lineChart")) {
           this.getLineChart(cmp); 
        } 
        if (cmp.get("v.stackedColumnChart")){
           this.getStackedColumnChart(cmp);
        }
    }, 
    
    // Get Line Chart
    getLineChart: function(cmp) {
        console.log("Inside getSalesChart");
        Highcharts.chart('HCP_Sales_Chart', {
            title: {
                text: cmp.get("v.header"), // Pass in from Configuration
                x: -20 //center
            },
            subtitle: {
                text: 'Past 6 months line',
                x: -20
            },
            xAxis: {
                title: {
                    text: cmp.get("v.xAxisLabel")
                },
                //Todo: This can be passed in dynamically from input
                categories: ['Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov'
                ]
            },
            yAxis: {
                title: {
                    text: cmp.get("v.yAxisLabel")
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: ''
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 1
            },
            //Series data can be retrieved dynamically in product from live data
            series: [{
                name: 'Lipitor',
                data: [15.0, 16.6, 15.9, 14.3, 9.0, 3.9],
                color: '#f7922e'
            }, {
                name: 'Aprodim',
                data: [13.2, 15.0, 14.6, 12.2, 8.3, 6.6],
                color: '#43b649'
            }]
        });
    },
    
    getStackedColumnChart: function(cmp) {
        Highcharts.chart('HCP_Sales_Chart', {
        chart: {
            type: 'column'
        },
        title: {
            text: cmp.get("v.header")
        },
        xAxis: {
            categories: ['Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov'
                ],
            title: {
                text: cmp.get("v.xAxisLabel")
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: cmp.get("v.yAxisLabel")
            },
            stackLabels: {
                enabled: true,
                style: {
                    fontWeight: 'bold',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                }
            }
        },
        legend: {
            align: 'right',
            verticalAlign: 'top',
            x: -3,
            y: 25,
            floating: true,
            backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            borderColor: '#CCC',
            borderWidth: 1,
            shadow: false
        },
        tooltip: {
            headerFormat: '<b>{point.x}</b><br/>',
            pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                }
            }
        },
        series: [{
            name: 'Lipitor',
            data: [15.0, 16.6, 15.9, 14.3, 9.0, 3.9],
            color: '#f7922e'
        }, {
            name: 'Aprodim',
            data: [13.2, 15.0, 14.6, 12.2, 8.3, 6.6],
            color: '#43b649'
        }]
    });
    }
})