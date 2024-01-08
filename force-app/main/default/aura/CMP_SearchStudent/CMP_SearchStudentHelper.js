({
    /** 
     * getListPage
     * Get list of page number
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    getListPage: function (component) {
        var currentPage = component.get("v.currentPage");
        var pageCount = component.get("v.pageCount");

        if (currentPage == 1) {
            component.set("v.disableFirst", true)
        }
        else {
            component.set("v.disableFirst", false)
        }

        if (currentPage == pageCount) {
            component.set("v.disableLast", true)
        }
        else {
            component.set("v.disableLast", false)
        }

        if (currentPage > pageCount) {
            currentPage = pageCount
        }
        else if (currentPage < 1) {
            currentPage = 1
        }

        if (pageCount < 2) {
            component.set("v.listPage", null);
        }
        else if (pageCount == 2) {
            component.set("v.listPage", [1, 2]);
        }
        else if (pageCount == 3) {
            component.set("v.listPage", [1, 2, 3]);
        }
        else if (pageCount == 4) {
            component.set("v.listPage", [1, 2, 3, 4]);
        }
        else {
            if (currentPage <= 2) {
                component.set("v.listPage", [1, 2, 3, 4, 5]);
            }
            else if (currentPage >= pageCount - 1) {
                component.set("v.listPage", [pageCount - 4, pageCount - 3, pageCount - 2, pageCount - 1, pageCount]);
            }
            else {
                component.set("v.listPage", [currentPage - 2, currentPage - 1, currentPage, currentPage + 1, currentPage + 2]);
            }
        }


        component.set("v.currentPage", currentPage)
    },

    /** 
     * getListPagi
     * Get list data of one page of pagination
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    getListPagi: function (component) {
        var pageCount = component.get("v.pageCount");
        var currentPage = component.get("v.currentPage");
        var pageSize = component.get("v.pageSize");
        var listStudent = component.get("v.Student");
        var listPagi = []
        if (pageCount > 1) {
            for (var i = (currentPage - 1) * pageSize; i < listStudent.length && i < (currentPage * pageSize); i++) {
                listPagi.push(listStudent[i]);
            }
        }
        else {
            listPagi = listStudent;
        }
        component.set("v.listDataOfPage", listPagi);
        this.checkState(component)
        this.deleteBtnState(component)
    },

    /** 
     * checkState
     * Check state of check all check box
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    checkState: function (component) {
        var countCheck = 0;
        var listPagi = component.get("v.listDataOfPage");
        var pageSize = component.get("v.pageSize")

        for (var i = 0; i < listPagi.length; i++) {
            if (listPagi[i].checked == true) {
                countCheck++;
            }
        }
        if (countCheck == listPagi.length && countCheck != 0) {
            component.set("v.checkAll", true)
        }
        else if (countCheck != pageSize) {
            component.set("v.checkAll", false)
        }

    },

    /** 
     * deleteBtnState
     * Disable or enable delete button
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    deleteBtnState: function (component) {
        var listOfAll = component.get("v.Student")
        var countCheck = 0;

        for (var i = 0; i < listOfAll.length; i++) {
            if (listOfAll[i].checked == true) {
                countCheck++;
            }
        }
        if (countCheck > 0) {
            component.set("v.deleteBtnState", false)
        }
        else if (countCheck == 0) {
            component.set("v.deleteBtnState", true)
        }

    },

    /** 
     * pageCount
     * Count page count
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    pageCount: function (component, event) {
        var listLength = component.get("v.Student").length;
        var pageSize = component.get("v.pageSize");
        var pageCount = parseInt(listLength / pageSize);
        if (listLength % pageSize != 0) {
            pageCount = pageCount + 1;
        }
        component.set("v.pageCount", pageCount);
    }
})
