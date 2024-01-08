({
    /** 
     * search
     * Search student
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    search: function (component, event, helper) {
        let inputBirthday = component.find("inputBirthday");
        let checkBirthday = inputBirthday.checkValidity();
        if (checkBirthday == false)
        {
            return;
        }
        component.set("v.isLoaded", true)
        var sexValue = component.get("v.sexValue")
       
        var action = component.get("c.searchStudent");
        action.setParams({
            "searchStudent": component.get("v.searchStudent"),
            "Sex": sexValue
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listSearchStudent = response.getReturnValue();
                listSearchStudent.map(item => {
                    item.checked = false;
                    return item;
                });
                component.set("v.Student", listSearchStudent);
                helper.pageCount(component);
                helper.getListPage(component)
                helper.getListPagi(component);

            }
            component.set("v.isLoaded", false)
            // Show or hide pagination if return value exist or not
            if (listSearchStudent.length == 0) {
                component.set("v.hidePagi", false)
            }
            else if (listSearchStudent.length != 0) {
                component.set("v.hidePagi", true)
            }
        });
        $A.enqueueAction(action);

    },

    /** 
     * showClass
     * Show class field
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    showClass: function (component, event, helper) {
        var action = component.get("c.getClass");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allClass = response.getReturnValue();
                component.set("v.options", allClass);
            }
        });
        $A.enqueueAction(action);
    },

    /** 
     * openCreateModal
     * Open modal create
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openCreateModal: function (component, event, helper) {
        component.set("v.stateCreate", true);
    },

    /** 
     * closeCreateModal
     * Close modal create
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeCreateModal: function (component, event, helper) {
        component.set("v.stateCreate", false);
    },

    /** 
     * openUpdateModal
     * Open modal update
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openUpdateModal: function (component, event, helper) {
        component.set("v.stateUpdate", true);
        var Id = event.getSource().get("v.value")
        var action = component.get("c.getDataById");
        action.setParams({
            "Id": Id
        });
        action.setCallback(this, function (response) {
            component.set("v.updateStudent", response.getReturnValue());
            console.log(response.getReturnValue());

        });
        $A.enqueueAction(action);
    },

    /** 
     * closeUpdateModal
     * Close modal update
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeUpdateModal: function (component, event, helper) {
        component.set("v.stateUpdate", false);
    },

    /** 
     * openDetailModal
     * Open modal detail
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openDetailModal: function (component, event, helper) {
        component.set("v.stateDetail", true);
        var Id = event.getSource().get("v.value")
        var action = component.get("c.getDataById");
        action.setParams({
            "Id": Id
        });
        action.setCallback(this, function (response) {
            component.set("v.detailStudent", response.getReturnValue());
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    // 
    /** 
     * closeDetailModal
     * Close modal detail
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeDetailModal: function (component, event, helper) {
        component.set("v.stateDetail", false);
    },

    /** 
     * deleteStudentOnRow
     * Delete student on row
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    deleteStudentOnRow: function (component, event, helper) {
        var listAfterDelete = component.get("v.Student");
        var Id = component.get("v.deleteId")
        var action = component.get("c.delStudentById");
        action.setParams({
            "Id": Id
        });

        action.setCallback(this, function (response) {
            for (var i = 0; i < listAfterDelete.length; i++) {
                if (listAfterDelete[i].Id == Id) {
                    listAfterDelete.splice(i, 1);
                }
            }
            component.set("v.Student", listAfterDelete)
            helper.pageCount(component);
            helper.getListPage(component);
            helper.getListPagi(component);
            component.set("v.askDeleteModal", false)

        })

        $A.enqueueAction(action);
    },

    /** 
     * changePage
     * Change number of page
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    changePage: function (component, event, helper) {
        var currentPage = event.getSource().get("v.value");
        component.set("v.currentPage", currentPage);
        component.set("v.checkAll", "false");
        helper.getListPage(component);
        helper.getListPagi(component);
        helper.checkState(component);
        helper.deleteBtnState(component)
    },

    /** 
     * checkAll
     * Check all check box on row when the state of checkall check box is true
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    checkAll: function (component, event) {
        var checked = event.getSource().get("v.checked");
        var listStudent = component.get("v.listDataOfPage");
        component.set("v.listDataOfPage", listStudent.map(item => {
            item.checked = checked;
            return item;
        }))
        if (checked == true) {
            component.set("v.deleteBtnState", false)
        }
        else {
            component.set("v.deleteBtnState", true)
        }
    },
 
     /** 
     * deleteCheck
     * Delete item that checked
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    deleteCheck: function (component, event, helper) {
        var listDel = [];
        var listAll = component.get("v.Student");
        var listUpdate = [];
        for (var i = 0; i < listAll.length; i++) {
            if (listAll[i].checked == true) {
                listDel.push(listAll[i].Id)
            }
        }

        var action = component.get("c.deleteMultiple");
        action.setParams({
            "listDelete": listDel
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                listUpdate = listAll.filter(item => !listDel.includes(item.Id));
                component.set("v.Student", listUpdate);
                component.set("v.currentPage", 1);
                helper.pageCount(component)
                helper.getListPage(component)
                helper.getListPagi(component);
            }
            component.set("v.askDeleteCheckModal", false)
        })
        $A.enqueueAction(action);
    },

     /** 
     * checkStateOnRow
     * Get onchange of checkbox on row
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    checkStateOnRow: function (component, event, helper) {
        helper.checkState(component);
        helper.deleteBtnState(component);
    },

     /** 
     * openUpdateModalInDetailModal
     * Event to open modal update when in modal detail
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openUpdateModalInDetailModal: function (component, event) {
        var message = event.getParam("message");
        component.set("v.updateStudent", message)
        console.log('message', message)
        component.set("v.stateDetail", false);
        component.set("v.stateUpdate", true);
    },

     /** 
     * askBeforeDelete
     * Ask yes or no for sure before delete
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    askBeforeDelete: function (component, event) {
        component.set("v.askDeleteModal", true)
        var Id = event.getSource().get("v.value")
        component.set("v.deleteId", Id)
    },

    /** 
     * closeAskDeleteModal
     * Close modal ask to delete
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeAskDeleteModal: function (component) {
        component.set("v.askDeleteCheckModal", false)
    },

    /** 
     * askBeforeDeleteCheck
     * Ask yes or no for sure before delete
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    askBeforeDeleteCheck: function (component, event) {
        component.set("v.askDeleteCheckModal", true)
    },

})
