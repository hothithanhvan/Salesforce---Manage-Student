({
    /** 
     * handleCreateStudent
     * Create student
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleCreateStudent: function (component, event) {
        var action = component.get("c.createStudent");
        action.setParams({
            "student": component.get("v.newStudent")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.insertStudent", response.getReturnValue());
                component.set("v.message", true)
                component.set("v.newStudent", null)

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
        component.set("v.insertStudent.Sex__c", false)
        var action = component.get("c.getClass");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                component.set("v.options", allValues);
            }
        });
        $A.enqueueAction(action);
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
        var birthDay = component.get("v.newStudent.BirthDay__c")
        console.log(birthDay);
        var splitDate = birthDay.split("-")
        console.log(JSON.stringify(splitDate));
        let dayOfToday = parseInt(dd)
        let monthOfToday = parseInt(mm)
        let yearOfToday = parseInt(yyyy)
        let dayOfDate = parseInt(splitDate[2])
        let monthOfDate = parseInt(splitDate[1])
        let yearOfDate = parseInt(splitDate[0])
        var disableCreate = true

        if (yearOfToday < yearOfDate) {
            disableCreate = true
        }
        else if (yearOfToday > yearOfDate) {
            disableCreate = false
        }
        else if (yearOfToday == yearOfDate) {
            if (monthOfToday < monthOfDate) {
                disableCreate = true
            }
            else if (monthOfToday > monthOfDate) {
                disableCreate = false
            }
            else if (monthOfToday == monthOfDate) {
                if (dayOfToday >= dayOfDate) {
                    disableCreate = false
                }
                if (dayOfToday < dayOfDate) {
                    disableCreate = true
                }
            }
        }
        console.log(disableCreate)
        component.set("v.disableSave", disableCreate)
    },

    /** 
     * closeNotify
     * Close notify when create successfully
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeNotify: function (component) {
        component.set("v.message", false)
        component.set("v.selectedTabs", "three");
        var createEvent = component.getEvent("createEvent");
        createEvent.fire();
    }
})