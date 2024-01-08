({
    /** 
     * editStudent
     * Update student
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    editStudent: function (component, event, helper) {
        var updateStudent = component.get("v.updateStudents")
        var action = component.get("c.updateStudent");
        action.setParams({
            "student": updateStudent
        });
        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.message", "Update successfully");
                var updateStudent = response.getReturnValue();
                component.set("v.updateStudents", updateStudent);
            }
        });

        $A.enqueueAction(action);
    },

    /** 
     * getClassJs
     * Get class field
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    getClassJs: function (component, event, helper) {
        var action = component.get("c.getClass");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                var items = [];
                for (var i = 0; i < allValues.length; i++) {
                    var item = {
                        "label": allValues[i].ClassName__c,
                        "value": allValues[i].Id
                    };
                    items.push(item);
                }
                component.set("v.options", items);
            }
        });

        $A.enqueueAction(action);
    },

    /** 
     * closeNotify
     * Close notify
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeNotify: function (component) {
        component.set("v.message", false)
        component.set("v.selectedTabs", "three")
        var updateEvent = component.getEvent("updateEvent");
        updateEvent.fire();
    },

    /** 
     * checkDate
     * Notify if date is not suitable
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    checkDate: function (component, event, helper) {
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        component.set("v.dateLimit", today)
        var birthDay = component.get("v.updateStudents.BirthDay__c")
        var splitDate = birthDay.split("-")

        // Convert to integer to compare 
        var dayOfToday = parseInt(dd)
        var monthOfToday = parseInt(mm)
        var yearOfToday = parseInt(yyyy)
        var dayOfDate = parseInt(splitDate[2])
        var monthOfDate = parseInt(splitDate[1])
        var yearOfDate = parseInt(splitDate[0])

        var disableUpdate = false

        if (yearOfToday < yearOfDate) {
            disableUpdate = true
        }
        else if (yearOfToday > yearOfDate) {
            disableUpdate = false
        }
        else if (yearOfToday == yearOfDate) {
            if (monthOfToday < monthOfDate) {
                disableUpdate = true
            }
            else if (monthOfToday > monthOfDate) {
                disableUpdate = false
            }
            else if (monthOfToday == monthOfDate) {
                if (dayOfToday >= dayOfDate) {
                    disableUpdate = false
                }
                if (dayOfToday < dayOfDate) {
                    disableUpdate = true
                }
            }
        }
        component.set("v.disableUpdate", disableUpdate)
    },
})
