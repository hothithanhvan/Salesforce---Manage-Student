({
    /** 
     * updateStudent
     * Move to Update tab
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    updateStudent: function (component, event, helper) {
        component.set("v.selectedTabs", "two")
        console.log('detail', component.get("v.detailStudents"))
        var updateEvent = component.getEvent("openUpdateModalInDM");
        updateEvent.setParams({
            "message" :  component.get("v.detailStudents")});
        updateEvent.fire();
    },

    /** 
     * deleteStudentJs
     * Delete student
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    deleteStudentJs: function (component, event, helper) {
        var student = component.get("v.detailStudents");
        var action = component.get("c.deleteStudent");

        action.setParams({
            "student": student
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.message", false)
                component.set("v.detailStudents", null)
                var deleteEvent = component.getEvent("deleteEvent");
                deleteEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    /** 
     * askBeforeDelete
     * Ask before delete
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    askBeforeDelete: function (component, event) {
        component.set("v.message", true)
    },

    /** 
     * closeAskDeleteModal
     * Close modal ask delete
     * @param 
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeAskDeleteModal: function (component, event) {
        component.set("v.message", false)
    },
})
