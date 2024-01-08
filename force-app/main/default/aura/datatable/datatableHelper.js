({
    fetchData: function (cmp, fetchData, numberOfRecords) {
        var fakeDataCmp = cmp.find('datafaker'),
            dataPromise = this.mockdataLibrary.lightningMockDataFaker(fetchData, numberOfRecords);

        dataPromise.then($A.getCallback(function (results) {
            cmp.set('v.data', results);
        }));

    },
    removeBook: function (cmp, row) {
        var rows = cmp.get('v.data');
        var rowIndex = rows.indexOf(row);

        rows.splice(rowIndex, 1);
        cmp.set('v.data', rows);
    }
});
