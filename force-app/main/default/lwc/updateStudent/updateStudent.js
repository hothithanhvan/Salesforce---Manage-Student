import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getClass from '@salesforce/apex/LWC_SearchStudentCtrl.getClass';
import updateStudent from '@salesforce/apex/LWC_SearchStudentCtrl.updateStudent';
import getDetailStudent from '@salesforce/apex/LWC_SearchStudentCtrl.getDetailStudent';

export default class UpdateStudent extends LightningElement {

    // Get Id from component search
    @api editid = ''

    // List to receive value of class field
    listClass = []

    // List to show class to view
    classOptions = []

     /** 
     * getClass
     * Get class
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    @wire(getClass)
    Class({ data, error }) {
        if (data) {
            this.listClass = data;
            this.error = undefined;
            let items = [];
            for (var i = 0; i < this.listClass.length; i++) {
                items.push({ label: this.listClass[i].ClassName__c, value: this.listClass[i].Id });
            }
            this.classOptions = items;
            this.student.Class__c = this.listClass[0].Id;
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
            console.log(error)
        }
    }

    // Student to update
    student = {}

     /** 
     * handleFNameChange
     * Get value of first name
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleFNameChange(event) {
        this.student.FirstName__c = event.target.value;
        console.log("f name", this.student.FirstName__c);
    }

     /** 
     * handleFNameChange
     * Get value of last name
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleLNameChange(event) {
        this.student.LastName__c = event.target.value;
        console.log("l name", this.student.LastName__c);
    }

    /** 
     * handleFNameChange
     * Get value of sex
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleSexChange(event) {
        let checkbox = this.template.querySelector('[data-id="checkbox"]')
        let value = checkbox.checked
        this.student.Sex__c = value;
        console.log("sex", this.student.Sex__c);
    }

    // Max to choose day
    today

    // Disable Update button
    disableUpdate

    /** 
     * handleBDayChange
     * Get value of birth day and check
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleBDayChange(event) {
        this.student.BirthDay__c = event.target.value;
        this.today = new Date();
        var dd = String(this.today.getDate()).padStart(2, '0');
        var mm = String(this.today.getMonth() + 1).padStart(2, '0');
        var yyyy = this.today.getFullYear();
        this.today = yyyy + '-' + mm + '-' + dd;
        var splitDate = this.student.BirthDay__c.split("-")
        let dayOfToday = parseInt(dd)
        let monthOfToday = parseInt(mm)
        let yearOfToday = parseInt(yyyy)
        let dayOfDate = parseInt(splitDate[2])
        let monthOfDate = parseInt(splitDate[1])
        let yearOfDate = parseInt(splitDate[0])

        if (yearOfToday < yearOfDate) {
            this.disableUpdate = true
        }
        else if (yearOfToday > yearOfDate) {
            this.disableUpdate = false
        }
        else if (yearOfToday == yearOfDate) {
            if (monthOfToday < monthOfDate) {
                this.disableUpdate = true
            }
            else if (monthOfToday > monthOfDate) {
                this.disableUpdate = false
            }
            else if (monthOfToday == monthOfDate) {
                if (dayOfToday >= dayOfDate) {
                    this.disableUpdate = false
                }
                if (dayOfToday < dayOfDate) {
                    this.disableUpdate = true
                }
            }
        }
        console.log("b day", this.student.BirthDay__c);
    }

    /** 
     * handleBDayChange
     * Get value of class
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleClassChange(event) {
        this.student.Class__c = event.target.value;
        console.log("class", this.student.Class__c);
    }

    connectedCallback() {
        console.log(this.editid)
        this.getDetailStudent()

    }
    /** 
     * getDetailStudent
     * Get detail of the student that users want to update
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    getDetailStudent(){
        getDetailStudent({ detailId: this.editid })
          .then(result => {
                this.student = { ...result };
                console.log(this.student);
            })
          .catch(error => {
                console.log(error);
            })
    }
   

    /** 
     * handleUpdate
     * Update student
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleUpdate() {
        console.log(JSON.stringify(this.student))
        updateStudent({ updateStudent: this.student })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if (this.message !== undefined) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Update Successfully',
                            variant: 'success',
                        }),
                    );
                }
                const event = new CustomEvent('reloaddata');
                this.dispatchEvent(event)
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });
    }


}