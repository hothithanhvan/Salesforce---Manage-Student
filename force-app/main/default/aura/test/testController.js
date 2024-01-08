({
    init: function (cmp) {
        var items = [];
        for (var i = 0; i < 500; i++) {
            var item = {
                "label": i + " Option",
                "value": i.toString()
            };
            items.push(item);
        }
        cmp.set("v.options", items);
    },
    handleChange: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
        alert("Option selected with value: '" + selectedOptionValue + "'");
    }
});
