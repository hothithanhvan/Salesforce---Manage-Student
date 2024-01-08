({
    init: function (cmp, event, helper) {
        var actions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Delete', name: 'delete' }
        ],
        fetchData = {
            name : 'company.companyName',
            author: 'name.findName',
            published : 'address.state'
        };


        cmp.set('v.columns', [
            { label: 'Name', fieldName: 'name', type: 'text' },
            { label: 'Author', fieldName: 'author', type: 'text' },
            { label: 'Publishing State', fieldName: 'published', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);


        helper.fetchData(cmp, fetchData, 20);
    },

    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        switch (action.name) {
            case 'show_details':
                alert('Showing Details: ' + JSON.stringify(row));
                break;
            case 'delete':
                helper.removeBook(cmp, row);
                break;
        }
    }
});
