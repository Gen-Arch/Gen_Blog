var data = [
  { label: 'Series1',
    values: [{ time: time, y: 100 }, { time: time + 1, y: 1000 }] },
  { label: 'Series2',
    values: [{ time: time, y: 200 }, { time: time + 1, y: 200 }] }
];


var lineChart = $('#lineChart').epoch({
    type: 'time.line',
    data: data
});
