/* eslint-disable no-console */
import { LightningElement, track, wire} from 'lwc';
import FIRSTNAME_FIELD from '@salesforce/schema/Student__c.FirstName__c';
import LASTNAME_FIELD from '@salesforce/schema/Student__c.LastName__c';
import SEX_FIELD from '@salesforce/schema/Student__c.Sex__c';
import BIRTHDAY_FIELD from '@salesforce/schema/Student__c.BirthDay__c';
import CLASS_FIELD from '@salesforce/schema/Student__c.Class__c';
import createStudent from '@salesforce/apex/LWC_SearchStudentCtrl.createStudent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getClass from '@salesforce/apex/LWC_SearchStudentCtrl.getClass';

export default class demo extends LightningElement {

    listClass
    @track TypeOptions;

    @wire(getClass)
    Class({ data,error }) {
        if (data) {
            this.listClass = data;
            this.error = undefined;
            let items = [];
            console.log(this.listClass.length)
            
            for (var i = 0; i < this.listClass.length; i++) {
                items.push({ label: this.listClass[i].ClassName__c, value: this.listClass[i].Id  });
            }
            this.TypeOptions = items;
            console.log(JSON.stringify(items))
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
            // console.log(error)
        }
    }

    @ track student = {
        FirstName__c : FIRSTNAME_FIELD,
        LastName__c : LASTNAME_FIELD,
        Sex__c : SEX_FIELD,
        BirthDay__c: BIRTHDAY_FIELD,
        Class__c: CLASS_FIELD
    }

    handleFNameChange(event) {
        this.student.FirstName__c = event.target.value;
        console.log("f name", this.student.FirstName__c);
    }
    
    handleLNameChange(event) {
        this.student.LastName__c = event.target.value;
        console.log("l name", this.student.LastName__c);
    }
    
    handleSexChange(event) {
        let checkbox = this.template.querySelector('[data-id="checkbox"]')
        let i = checkbox.checked
        this.student.Sex__c = i;

        console.log("sex", this.student.Sex__c);
    }
    
    handleBDayChange(event) {
        this.student.BirthDay__c = event.target.value;
        console.log("b day", this.student.BirthDay__c);
    }

    handleClassChange(event) {
        this.student.Class__c = event.target.value;
        console.log("class", this.student.Class__c);
    }
    handleClick() {
        console.log(JSON.stringify(this.student))
        createStudent({ insertStudent : this.student })
            .then(result => {
                console.log('thanh cong');
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                    
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Account created',
                            variant: 'success',
                        }),
                    );
                }
                
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                console.log('that bai')
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