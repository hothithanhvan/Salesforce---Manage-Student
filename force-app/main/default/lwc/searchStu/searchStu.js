import { LightningElement, wire, track, api } from 'lwc';
import FULLNAME_FIELD from '@salesforce/schema/Student__c.FullName__c';
import SEX_FIELD from '@salesforce/schema/Student__c.Sex__c';
import BIRTHDAY_FIELD from '@salesforce/schema/Student__c.BirthDay__c';
import FIRSTNAME_FIELD from '@salesforce/schema/Student__c.FirstName__c';
import LASTNAME_FIELD from '@salesforce/schema/Student__c.LastName__c';
import CLASS_FIELD from '@salesforce/schema/Student__c.Class__c';
import STUDENTCODE_FIELD from '@salesforce/schema/Student__c.StudentCode__c';
import getClass from '@salesforce/apex/LWC_SearchStudentCtrl.getClass';
import searchStudent from '@salesforce/apex/LWC_SearchStudentCtrl.searchStudent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteCheck from '@salesforce/apex/LWC_SearchStudentCtrl.deleteCheck';
import getDetailStudent from '@salesforce/apex/LWC_SearchStudentCtrl.getDetailStudent';
import getAllStudent from '@salesforce/apex/LWC_SearchStudentCtrl.getAllStudent';
import deleteStudent from '@salesforce/apex/LWC_SearchStudentCtrl.deleteOnRow';



export default class SearchStu extends LightningElement {

    // Get value of student to search
    @track searchStudent = {
        FullName__c: FULLNAME_FIELD,
        StudentCode__c: STUDENTCODE_FIELD,
        Sex__c: SEX_FIELD,
        BirthDay__c: BIRTHDAY_FIELD,
        Class__c: CLASS_FIELD
    }

    // Send data from search component to detail component
    @api student = {
        FirstName__c: FIRSTNAME_FIELD,
        LastName__c: LASTNAME_FIELD,
        Sex__c: SEX_FIELD,
        BirthDay__c: BIRTHDAY_FIELD,
        Class__c: CLASS_FIELD
    }

    // Get value of class
    listClass = []

    // Get list of student
    @track listStudent

    // Disable or enable delete button
    deleteBtnState = true

    // Get all student at the first load
    @wire(getAllStudent)
    Student({ data, error }) {
        if (data) {
            this.listStudent = data.map((item, index) => ({
                ...item,
                check: false,
                index: index + 1,
                className: item.Class__c ? item.Class__r.ClassName__c : ''
            }))
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
            console.log(this.error)
        }
    }

    // Get class at the first load
    @wire(getClass)
    Class({ data, error }) {
        if (data) {
            this.listClass = data;
            this.error = undefined;
            let items = [];
            items.push({ label: 'None', value: 'None' });
            console.log(this.listClass.length)

            for (var i = 0; i < this.listClass.length; i++) {
                items.push({ label: this.listClass[i].ClassName__c, value: this.listClass[i].Id });
            }
            this.listClass = items;
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
        }
    }

    handleFNameChange(event) {
        this.searchStudent.FullName__c = event.target.value;
        console.log("F name", this.searchStudent.FullName__c);
    }

    handleSexChange(event) {
        let checkbox = this.template.querySelector('[data-id="checkbox"]')
        let value = checkbox.checked
        this.searchStudent.Sex__c = value;
        console.log("sex", this.searchStudent.Sex__c);
    }

    handleBDayChange(event) {
        this.searchStudent.BirthDay__c = event.target.value;
        console.log("b day", this.searchStudent.BirthDay__c);
    }

    handleClassChange(event) {
        this.searchStudent.Class__c = event.target.value;
        console.log("class", this.searchStudent.Class__c);
    }

    handleStudentCodeChange(event) {
        this.searchStudent.StudentCode__c = event.target.value;
        console.log("studentcode", this.searchStudent.StudentCode__c);
    }


    connectedCallback() {
        this.searchStudent = {
            FullName__c: '',
            StudentCode__c: '',
            Sex__c: '',
            BirthDay__c: '',
            Class__c: ''
        }
    }

    // Define the value of page size
    pageSize = 2

    // Define the value of page count
    // Page count is the number of total page when doing pagination
    pageCount = 0

    // Caculate pageCount
    countPageCount() {
        let listLength = this.listStudent.length
        this.pageCount = parseInt(listLength / this.pageSize);
        if (listLength % this.pageSize != 0) {
            this.pageCount = this.pageCount + 1;
        }
    }

    // Define the value of current page
    currentPage = 1

    // Store the value of list page of pagination
    @track listPage = []

    // Get value of listPage
    getListPage() {
        this.countPageCount();
        if (this.currentPage > this.pageCount) {
            this.currentPage = this.pageCount
        }
        else if (this.currentPage < 1) {
            this.currentPage = 1
        }

        if (this.pageCount > 2) {
            if (this.currentPage == 1) {
                this.listPage = [{ number: 1, variant: 'brand' },
                { number: 2, variant: '' },
                { number: 3, variant: '' }];

            }
            else if (this.currentPage == this.pageCount) {
                this.listPage = [{ number: this.pageCount - 2, variant: '' },
                { number: this.pageCount - 1, variant: '' },
                { number: this.pageCount, variant: 'brand' }];

            }
            else if (this.currentPage < this.pageCount) {
                this.listPage = [{ number: this.currentPage - 1, variant: '' },
                { number: this.currentPage, variant: 'brand' },
                { number: this.currentPage + 1, variant: '' }]
            }
        }
        else if (this.pageCount < 2) {
            this.listPage = []
        }
        else if (this.pageCount == 2) {
            this.listPage = [{ number: 1, variant: 'brand' },
            { number: 2, variant: '' }];
        }
        if (this.pageCount == 2 && this.currentPage == 2) {
            this.listPage = [{ number: 1, variant: '' },
            { number: 2, variant: 'brand' }];
        }
    }

    // Show or not show pagi depending on the length of list student
    isShowPagi = false

    // Show notify if list student is empty
    isShowStudent = false

    // Value of list pagination
    get getListPagination() {
        try {
            var listPagi = []
            this.getListPage()
            if (this.pageCount > 1) {
                for (let i = (this.currentPage - 1) * this.pageSize; i < this.listStudent.length && i < (this.currentPage * this.pageSize); i++) {
                    listPagi.push(this.listStudent[i]);
                }
            }
            else if (this.pageCount < 2) {
                listPagi = this.listStudent;
            }
            if (this.listStudent.length > 0) {
                this.isShowPagi = true;
                this.isShowStudent = false
            }
            else if (this.listStudent.length == 0) {
                this.isShowPagi = false
                this.isShowStudent = true
            }

            return listPagi;
        }
        catch (error) {
            console.log(error)
            return [];
        }
    }

    // Value of Sex, it may be true, false and ''
    sexValue

    // Set value of sexValue
    setSexValue() {
        try {
            let isMale = this.template.querySelector('[data-id="male"]')
            let isFemale = this.template.querySelector('[data-id="female"]')

            if (isMale.checked == true && isFemale.checked == false) {
                this.sexValue = 'true'
            }
            else if (isMale.checked == false && isFemale.checked == true) {
                this.sexValue = 'false'
            }
            else if (isMale.checked == true && isFemale.checked == true) {
                this.sexValue = ''
            }
            else if (isMale.checked == false && isFemale.checked == false) {
                this.sexValue = ''
            }
        }
        catch (error) {
            console.log(error)
        }
    }

    // Show loading icon
    loaded = false

    // Search student
    search() {
        this.loaded = true
        const student = this.searchStudent
        const sex = this.sexValue
        searchStudent({ student: student, sex: sex })
            .then(result => {
                this.listStudent = result.map((item, index) => ({
                    ...item,
                    check: false,
                    index: index + 1,
                    className: item.Class__c ? item.Class__r.ClassName__c : ''
                }))
                this.loaded = false
                if (this.listStudent.length > 0) {
                    this.isShowPagi = true;
                    this.isShowStudent = false
                }
                else if (this.listStudent.length == 0) {
                    this.isShowPagi = false
                    this.isShowStudent = true

                }
            })
            .catch(error => {
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

    // Check checkall checkbox if users check all theckbox on row
    checkCheckAll() {
        let countCheck = 0;
        let listPagilength = 0;
        for (let i = (this.currentPage - 1) * this.pageSize; i < this.listStudent.length && i < (this.currentPage * this.pageSize); i++) {
            listPagilength++
            if (this.listStudent[i].check == true) {
                countCheck++
            }
        }
        let checkAll = this.template.querySelector('[data-id="checkAll"]')

        if (countCheck == listPagilength) {
            checkAll.checked = true
        }
        if (countCheck < listPagilength) {
            checkAll.checked = false
        }
    }

    // Check the status of checkbox on row
    statusCheckbox(event) {

        let statusCheck = parseInt(event.target.value);
        let index = parseInt((this.currentPage - 1) * this.pageSize + statusCheck)
        if (event.target.checked == true) {
            this.listStudent[index].check = true
        }
        else if (event.target.checked == false) {
            this.listStudent[index].check = false
        }
        this.checkCheckAll()
        this.disableDelete()
    }

    // Change the page 
    changePage(event) {
        this.disableDelete()
        let changePage = event.target.value
        if (changePage == "previousPage") {
            this.currentPage = this.currentPage - 1
            if (this.currentPage < 2) {
                this.currentPage = 1
            }
        }
        else if (changePage == "nextPage") {
            this.currentPage = this.currentPage + 1

            if (this.currentPage > this.pageCount) {
                this.currentPage = this.pageCount
            }
        }
        else if (changePage != "previousPage" && changePage != "nextPage") {
            this.currentPage = event.target.value
        }

        let checkAll = this.template.querySelector('[data-id="checkAll"]')
        checkAll.checked = false
        this.checkCheckAll()
    }

    // Value to send data to component detail
    @api detailStudent = {}

    // Show modal create or not
    isShowCreateModal = false

    // Show modal create
    handleCreate() {
        this.isShowCreateModal = true
    }

    // Close modal create
    closeCreateModal() {
        this.isShowCreateModal = false
    }

    // Show modal detail or not
    isShowDetailModal = false

    // Open modal detail
    openDetailModal(event) {
        let Id = event.target.value
        this.isShowDetailModal = true
        getDetailStudent({ Id: Id })
            .then(result => {
                this.detailStudent = {
                    ...result,
                    className: result.Class__c ? result.Class__r.ClassName__c : ''
                }
            })
            .catch(error => {
                console.log(error)
            })
    }

    // Close modal detail
    closeDetailModal() {
        this.isShowDetailModal = false
    }

    // Show modal update or not
    isShowUpdateModal = false

    // Send ID of record to component update
    @api updateId

    // Open update modal
    openUpdateModal(event) {
        this.isShowUpdateModal = true
        const Id = event.target.value
        this.updateId = Id
    }

    // Close update modal
    closeUpdateModal() {
        this.isShowUpdateModal = false
    }

    // Show modal to ask before delete or not
    isShowDeleteModal = false

    // Delete Id
    deleteId

    // Open delete modal
    openDeleteModal(event) {
        this.deleteId = event.target.value
        this.isShowDeleteModal = true
    }

    // Close delete modal
    closeDeleteModal() {
        this.isShowDeleteModal = false
    }

    // Delete one record
    async deleteOnRow(event) {
        await deleteStudent({ Id: this.deleteId })
        this.isShowDeleteModal = false
        this.search()
    }

    listIdCheck = []
    // Delete multiple
    async handleDelete() {
        for (let i = 0; i < this.listStudent.length; i++) {
            if (this.listStudent[i].check == true) {
                this.listIdCheck.push(this.listStudent[i].Id)
            }
        }
        await deleteCheck({ listId: this.listIdCheck });
        this.search()
        let checkAll = this.template.querySelector('[data-id="checkAll"]')
        checkAll.checked = false
        this.isShowDeleteCheckModal = false
    }

    // Check all the checkbox on row if the button checkall is true
    checkAll(event) {
        let status = event.target.checked;
        if (status == true) {
            for (let i = (this.currentPage - 1) * this.pageSize; i < this.listStudent.length && i < (this.currentPage * this.pageSize); i++) {
                this.listStudent[i].check = true
            }
        }
        else if (status == false) {
            for (let i = (this.currentPage - 1) * this.pageSize; i < this.listStudent.length && i < (this.currentPage * this.pageSize); i++) {
                this.listStudent[i].check = false
            }
        }
        this.disableDelete()
    }

    // Disable delete button if no student are checked
    disableDelete() {
        let countCheck = 0
        for (let i = 0; i < this.listStudent.length; i++) {
            if (this.listStudent[i].check == true) {
                countCheck++;
            }
        }
        if (countCheck > 0) {
            this.deleteBtnState = false
        }
        else if (countCheck == 0) {
            this.deleteBtnState = true
        }
    }

    // Show modal to ask before delete
    isShowDeleteCheckModal = false

    // Open delete modal
    openDeleteCheckModal() {
        this.isShowDeleteCheckModal = true
    }

    // Close delete modal
    closeDeleteCheckModal() {
        this.isShowDeleteCheckModal = false

    }

}
let list = [1,2,3,5,6,7];
let socantim;
for (let i = 0; i < list.length; i++) {
    if ((list[i + 1] - list[i]) > 1) {
        socantim = list[i] + 1;
    }
}
console.log(socantim);