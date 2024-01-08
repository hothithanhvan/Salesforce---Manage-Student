import { LightningElement, wire, track, api } from 'lwc';
import getClass from '@salesforce/apex/LWC_SearchStudentCtrl.getClass';
import searchStudent from '@salesforce/apex/LWC_SearchStudentCtrl.searchStudent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteCheck from '@salesforce/apex/LWC_SearchStudentCtrl.deleteCheck';
import getDetailStudent from '@salesforce/apex/LWC_SearchStudentCtrl.getDetailStudent';
import getAllStudent from '@salesforce/apex/LWC_SearchStudentCtrl.getAllStudent';
import deleteStudent from '@salesforce/apex/LWC_SearchStudentCtrl.deleteOnRow';
import getAllTerm from '@salesforce/apex/LWC_SearchStudentCtrl.getAllTerm';
import getAllSubject from '@salesforce/apex/LWC_SearchStudentCtrl.getAllSubject';


export default class SearchStudent extends LightningElement {

    // Get value of student to search
    @track searchStudent = {
        FullName__c: '',
        StudentCode__c: '',
        Sex__c: '',
        BirthDay__c: '',
        Class__c: ''
    }

    // Get value of class
    listClass = []

    // Get list of student
    @track listStudent

    // Disable or enable delete button
    deleteBtnState = true


    /** 
    * getAllStudent
    * Get all student
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    async getAllStudent() {
        const data = await getAllStudent()
        this.listStudent = data.map((item, index) => ({
            ...item,
            check: false,
            index: index + 1,
            className: item.Class__c ? item.Class__r.ClassName__c : '',
            highlight: '',
            avgScore: item.avgScore__c?.toFixed(2)
        }))
    }

    connectedCallback() {
        this.getAllStudent()
        this.getAllTerm()
        this.getAllSubject()
    }

    // Length of list student
    get lengthOfListStudent() {
        if (this.listStudent != null) {
            let length = this.listStudent.length;
            return length
        }
        return 0

    }

    /** 
    * getClass
    * Get class at the first load
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    @wire(getClass)
    Class({ data, error }) {
        if (data) {
            this.listClass = data;
            this.error = undefined;
            let items = [];
            items.push({ label: 'None', value: 'None' });

            for (var i = 0; i < this.listClass.length; i++) {
                items.push({ label: this.listClass[i].ClassName__c, value: this.listClass[i].Id });
            }
            this.searchStudent.Class__c = 'None'
            this.listClass = items;
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
        }
    }

    /** 
    * handleFNameChange
    * Get value of first name
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleFNameChange(event) {
        this.searchStudent.FullName__c = event.target.value;
        console.log("F name", this.searchStudent.FullName__c);
    }

    /** 
    * handleFNameChange
    * Get value of term
    * @param
    * @return
    * @created: 2023/08/22 Ho Thi Thanh Van
    * @modified 
    */
    handleTermChange(event) {
        this.termSearch = event.target.value;
        console.log("Term", this.termSearch);
    }

    /** 
    * handleSubjectChange
    * Get value of subject
    * @param
    * @return
    * @created: 2023/08/22 Ho Thi Thanh Van
    * @modified 
    */
    handleSubjectChange(event) {
        this.subjectSearch = event.target.value;
        console.log("Subject", this.subjectSearch);
    }

    /** 
    * handleScoreFromChange
    * Get value of score from
    * @param
    * @return
    * @created: 2023/08/22 Ho Thi Thanh Van
    * @modified 
    */
    handleScoreFromChange(event) {
        this.scoreFrom = event.target.value;
        this.validateScore();
        console.log("score from", this.scoreFrom);
    }

    /** 
    * handleScoreToChange
    * Get value of score to
    * @param
    * @return
    * @created: 2023/08/22 Ho Thi Thanh Van
    * @modified 
    */
    handleScoreToChange(event) {
        this.scoreTo = event.target.value;
        this.validateScore();
        console.log("score to", this.scoreTo);
    }


    /** 
    * handleSexChange
    * Get value of sex
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleSexChange(event) {
        this.sexValue = event.target.value
        console.log("sex", this.sexValue);
    }

    // Value of birthday to search from
    birthdayFrom

    // Value of birthday to search to
    birthdayTo

    /** 
    * handleBDFromChange
    * Get value of birthdayFrom
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleBDFromChange(event) {
        let birthdayField = this.template.querySelector('[data-id="birthDayFromId"]')
        let isBirthday = birthdayField.checkValidity();
        if (isBirthday == false) {
            this.disableSearch = true
        }
        else {
            this.disableSearch = false
        }
        this.birthdayFrom = event.target.value;
    }

    /** 
    * handleBDToChange
    * Get value of birthdayTo
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleBDToChange(event) {
        let birthdayField = this.template.querySelector('[data-id="birthDayToId"]')
        let isBirthday = birthdayField.checkValidity();
        if (isBirthday == false) {
            this.disableSearch = true
        }
        else {
            this.disableSearch = false
        }
        this.birthdayTo = event.target.value;
    }

    /** 
    * handleClassChange
    * Get value of class
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleClassChange(event) {
        this.searchStudent.Class__c = event.target.value;
        console.log("class", this.searchStudent.Class__c);
    }

    /** 
    * handleStudentCodeChange
    * Get value of student code
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    handleStudentCodeChange(event) {
        this.searchStudent.StudentCode__c = event.target.value;
        console.log("studentcode", this.searchStudent.StudentCode__c);
    }


    // Disable or enable search button
    disableSearch = false

    // Define the value of page size
    pageSize = 10

    // Define the value of page count
    // Page count is the number of total page when doing pagination
    pageCount = 0

    /** 
     * countPageCount
     * Caculate pageCount
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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
    listPage = []

    /** 
     * getListPage
     * Get value of listPage
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    getListPage() {
        this.countPageCount();
        const listPagesSize = 5;
        if (this.currentPage > this.pageCount) {
            this.currentPage = this.pageCount
        }
        else if (this.currentPage < 1) {
            this.currentPage = 1
        }

        const calculateListPage = (index, length) => {
            let pages = []
            for (var i = index; i <= length; i++) {
                pages.push({ number: i, variant: '' })
            }

            return pages;
        }

        if (this.pageCount < 2) {
            this.listPage = []
        }
        else if (this.pageCount < listPagesSize) {
            this.listPage = calculateListPage(1, this.pageCount);
        }
        else {
            if (this.currentPage < (listPagesSize + 1) / 2) {
                this.listPage = calculateListPage(1, listPagesSize);
            }

            else if (this.currentPage > this.pageCount - (listPagesSize - 1) / 2) {
                this.listPage = calculateListPage(this.pageCount - (listPagesSize - 1), this.pageCount);
            }

            else {
                this.listPage = calculateListPage(this.currentPage - (listPagesSize - 1) / 2, this.currentPage + (listPagesSize - 1) / 2);
            }
        }

        for (let i = 0; i < this.listPage.length; i++) {
            if (this.listPage[i].number == this.currentPage) {
                this.listPage[i].variant = 'brand'
            }
        }

    }

    // Disable or enable firstpage
    get disableFirstPage() {
        if (this.currentPage == 1) {
            return true
        }
        return false
    }

    // Disable or enable lastpage
    get disableLastPage() {
        if (this.currentPage == this.pageCount) {
            return true
        }
        return false
    }

    // Show or not show pagi depending on the length of list student
    isShowPagi = false

    // Show notify if list student is empty
    isShowStudent = false

    /** 
     * getListPagination
     * Value of list pagination
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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

    // Sex options
    sexOptions = [
        { value: 'all', label: 'All' },
        {
            value: 'male',
            label: 'Male',
        },
        {
            value: 'female',
            label: 'Female',
        },
    ];

    // Value of Sex, it may be true, false and ''
    sexValue = 'all'

    // Show loading icon
    isLoaded = false

    /** 
     * search
     * Search student
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    search() {
        this.isLoaded = true
        const student = this.searchStudent
        const sex = this.sexValue
        const fromBD = this.birthdayFrom
        const toBD = this.birthdayTo

        searchStudent({ student: student, sex: sex, birthDayFrom: fromBD, birthDayTo: toBD, 
            termSearch: this.termSearch, subjectSearch: this.subjectSearch, 
            scoreFrom: this.scoreFrom == '' ? null : this.scoreFrom, 
            scoreTo: this.scoreTo == '' ? null : this.scoreTo})
            .then(result => {
                this.listStudent = result.map((item, index) => ({
                    ...item,
                    check: false,
                    index: index + 1,
                    className: item.Class__c ? item.Class__r.ClassName__c : '',
                    highlight: '',
                    avgScore: item.avgScore__c?.toFixed(2)
                }))
                this.isLoaded = false
                console.log('loading', this.isLoaded)
                if (this.listStudent.length > 0) {
                    this.isShowPagi = true;
                    this.isShowStudent = false
                }
                else if (this.listStudent.length == 0) {
                    this.isShowPagi = false
                    this.isShowStudent = true
                }
                let checkAll = this.template.querySelector('[data-id="checkAll"]')
                checkAll.checked = false
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

    /** 
     * checkCheckAll
     * Check checkall checkbox if users check all theckbox on row
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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

        if (countCheck == listPagilength && countCheck != 0) {
            checkAll.checked = true
        }
        if (countCheck < listPagilength) {
            checkAll.checked = false
        }
    }

    /** 
     * statusCheckbox
     * Check the status of checkbox on row
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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

    /** 
     * changePage
     * Change the page
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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
            this.currentPage++;
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

    /** 
     * handleCreate
     * Show modal create
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    handleCreate() {
        this.isShowCreateModal = true
        this.openBlurBackground()
    }

    /** 
     * closeCreateModal
     * Close modal create
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeCreateModal() {
        this.isShowCreateModal = false
    }

    // Show modal detail or not
    isShowDetailModal = false

    /** 
     * openDetailModal
     * Open modal detail
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    async openDetailModal(event) {
        this.openBlurBackground()
        try {
            let Id = event.target.value
            this.isLoaded = true
            await getDetailStudent({ detailId: Id })
                .then(result => {
                    this.detailStudent = {
                        ...result,
                        className: result.Class__c ? result.Class__r.ClassName__c : '',
                        avgScore: result.avgScore__c?.toFixed(2)
                    }
                })
                .catch(error => {
                    console.log(error)
                })
            this.isLoaded = false
            this.isShowDetailModal = true
            console.log('detail', JSON.stringify(this.detailStudent));
        }
        catch (error) {
            console.log(error)
        }
    }

    /** 
     * openDetailModal
     * Open modal detail
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openBlurBackground() {
        var blur = this.template.querySelector('[data-id="blurBackground"]');
        blur.style.display = "flex";
    }

    /** 
     * closeBlurBackground
     * Close blur background
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeBlurBackground() {
        var blur = this.template.querySelector('[data-id="blurBackground"]');
        blur.style.display = "none";
    }

    /** 
     * closeModal
     * Close all modal and blur background
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeModal() {
        this.isShowDetailModal = false
        this.isShowCreateModal = false
        this.isShowUpdateModal = false
        this.isShowDeleteModal = false
        this.isShowDeleteCheckModal = false
        this.closeBlurBackground()
    }

    /** 
     * openDetailModalonRow
     * doubleclick to show details
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    async openDetailModalonRow(event) {
        this.openBlurBackground()
        var row = event.target.parentNode;
        var rowIndex = row.rowIndex;
        console.log("Row index: " + rowIndex);
        let Id = this.getListPagination[rowIndex - 1].Id;
        await getDetailStudent({ detailId: Id })
            .then(result => {
                this.detailStudent = {
                    ...result,
                    className: result.Class__c ? result.Class__r.ClassName__c : '',
                    avgScore: result.avgScore__c?.toFixed(2)
                }
            })
            .catch(error => {
                console.log(error)
            })
        this.isLoaded = false
        this.isShowDetailModal = true
    }

    /** 
     * clearResult
     * Clear the result of search
     * @param
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    async clearResult() {
        const listClear = await getAllStudent({})
        console.log(listClear);
        this.listStudent = listClear.map((item, index) => ({
            ...item,
            check: false,
            index: index + 1,
            className: item.Class__c ? item.Class__r.ClassName__c : ''
        }));
        this.searchStudent = {
            FullName__c: '',
            StudentCode__c: '',
            Class__c: ''
        }
        this.disableSearch = false
        let bdFrom = this.template.querySelector('[data-id="birthDayFromId"]')
        bdFrom.value = null
        bdFrom.reportValidity()

        let bdTo = this.template.querySelector('[data-id="birthDayToId"]')
        bdTo.value = null
        bdTo.reportValidity()

        this.sexValue = 'all'

        this.searchStudent.Class__c = 'None'

        let checkAll = this.template.querySelector('[data-id="checkAll"]')
        checkAll.checked = false

        let scoreFrom = this.template.querySelector('[data-id="scoreFromId"]')
        scoreFrom.value = null
        scoreFrom.setCustomValidity("")
        scoreFrom.reportValidity();
        console.log('score f', scoreFrom.reportValidity());

        let scoreTo = this.template.querySelector('[data-id="scoreToId"]')
        scoreTo.value = null
        scoreTo.setCustomValidity("")
        scoreTo.reportValidity();

        this.termSearch = 'None'
        this.subjectSearch = 'All'
    }

    /** 
     * closeDetailModal
     * Close modal detail
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeDetailModal() {
        var blur = this.template.querySelector('[data-id="blurBackground"]');
        blur.style.display = "none";
        console.log('modal');
        this.isShowDetailModal = false
    }

    // Show modal update or not
    isShowUpdateModal = false

    // Send ID of record to component update
    @api updateId

    /** 
     * openUpdateModal
     * Open update modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openUpdateModal(event) {
        this.isShowUpdateModal = true
        const Id = event.target.value
        this.updateId = Id
        this.openBlurBackground()
        console.log(this.updateId);
    }

    /** 
     * closeUpdateModal
     * Close update modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeUpdateModal() {
        this.isShowUpdateModal = false
    }

    // Show modal to ask before delete or not
    isShowDeleteModal = false

    // Deleted Id
    deleteId

    // Name of student that want to delete
    nameDelete

    /** 
     * openDeleteModal
     * Open delete modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openDeleteModal(event) {
        this.deleteId = event.target.value
        this.nameDelete = event.target.name;
        console.log('name delete', this.nameDelete);
        this.isShowDeleteModal = true
        this.openBlurBackground()

    }

    /** 
     * closeDeleteModal
     * Close delete modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeDeleteModal() {
        this.isShowDeleteModal = false
        this.closeBlurBackground()
    }

    /** 
     * deleteOnRow
     * Delete one record
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    deleteOnRow(event) {
        deleteStudent({ deleteId: this.deleteId })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Delete Successfully',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error',
                    }),);
            })

        this.closeModal()
        this.search()
    }

    // List to delete mmultiple records
    listIdCheck = []

    /** 
     * handleDelete
     * Delete multiple
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    async deleteMultiple() {
        for (let i = 0; i < this.listStudent.length; i++) {
            if (this.listStudent[i].check == true) {
                this.listIdCheck.push(this.listStudent[i].Id)
            }
        }
        console.log(this.listIdCheck);
        await deleteCheck({ listId: this.listIdCheck });
        this.search()
        let checkAll = this.template.querySelector('[data-id="checkAll"]')
        checkAll.checked = false
        this.closeModal()
        this.listIdCheck = []
    }

    /** 
     * checkAll
     * Check all the checkbox on row if the button checkall is true
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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
        console.log(JSON.stringify(this.listStudent));
        this.disableDelete()
    }

    /** 
     * disableDelete
     * Disable delete button if no student are checked
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
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

    /** 
     * openDeleteCheckModal
     * Open delete modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    openDeleteCheckModal() {
        this.isShowDeleteCheckModal = true
        this.openBlurBackground()
        for (let i = 0; i < this.listStudent.length; i++) {
            if (this.listStudent[i].check == true) {
                this.listIdCheck.push(this.listStudent[i].Id)
            }
        }
        console.log(JSON.stringify(this.listIdCheck));
    }

    /** 
     * closeDeleteCheckModal
     * Close delete modal
     * @param
     * @return
     * @created: 2023/08/01 Ho Thi Thanh Van
     * @modified 
     */
    closeDeleteCheckModal() {
        this.isShowDeleteCheckModal = false
    }

    /** 
     * highlightRow
     * Highlight the row when clicked
     * @param
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    highlightRow(event) {
        console.log(event.target.dataset.id)
        this.listStudent = this.listStudent.map(student => {
            student.highlight = ''
            student.highlight = student.Id === event.target.dataset.id && 'highlightRow';
            return student;
        })
    }

    isSortFullName = true

    /** 
     * Sort
     * Sort full name field
     * @param
     * @return
     * @created: 2023/08/14 Ho Thi Thanh Van
     * @modified 
     */
    sortFullName(event) {
        var field = 'FullName__c'
        this.isSortFullName = !this.isSortFullName;
        if (this.isSortFullName) {
            this.listStudent.sort((a, b) => {
                const FullNameA = a[field].toUpperCase();
                const FullNameB = b[field].toUpperCase();
                if (FullNameA < FullNameB) {
                    return -1;
                }
                if (FullNameA > FullNameB) {
                    return 1;
                }
                return 0;
            })
        }
        else {
            this.listStudent.sort((a, b) => {
                const FullNameA = a[field].toUpperCase();
                const FullNameB = b[field].toUpperCase();
                if (FullNameA < FullNameB) {
                    return 1;
                }
                if (FullNameA > FullNameB) {
                    return -1;
                }
                return 0;
            })
        }
    }

    // Value of search term
    termSearch

    // Value of search subject
    subjectSearch

    // Value of search score from
    scoreFrom

    // Value of search score to
    scoreTo

    // List of all term
    listAllTerm

    /** 
     * getAllTerm
     * Get all term
     * @param
     * @return
     * @created: 2023/08/14 Ho Thi Thanh Van
     * @modified 
     */
    async getAllTerm() {
        const data = await getAllTerm();
        this.listAllTerm = data;
        let items = [];
        items.push({ label: 'None', value: 'None' });

        for (var i = 0; i < this.listAllTerm.length; i++) {
            items.push({ label: this.listAllTerm[i].Name, value: this.listAllTerm[i].Id });
        }
        this.termSearch = 'None'
        this.listAllTerm = items;
    }

    // List of all subject
    listAllSubject

    /** 
     * getAllSubject
     * Get all subject
     * @param
     * @return
     * @created: 2023/08/14 Ho Thi Thanh Van
     * @modified 
     */
    async getAllSubject() {
        const data = await getAllSubject();
        this.listAllSubject = data;
        let items = [];
        items.push({ label: 'All', value: 'All' });

        for (var i = 0; i < this.listAllSubject.length; i++) {
            items.push({ label: this.listAllSubject[i].Name, value: this.listAllSubject[i].Id });
        }
        this.subjectSearch = 'All'
        this.listAllSubject = items;
    }

    /** 
     * validateScore
     * Validate the score
     * @param
     * @return
     * @created: 2023/08/14 Ho Thi Thanh Van
     * @modified 
     */
    validateScore() {
        let scoreFrom  = this.template.querySelector('[data-id="scoreFromId"]')
        let scoreTo  = this.template.querySelector('[data-id="scoreToId"]')
        scoreFrom.setCustomValidity(scoreFrom.value < 0 || scoreFrom.value > 10 ? "Invalid Score" : "");
        scoreTo.setCustomValidity(scoreTo.value > 10 || scoreTo.value < 0 ? "Invalid Score" : "");
        if (scoreFrom.checkValidity() == false || scoreTo.checkValidity() == false) {
            if (scoreFrom.value > 10 || scoreFrom.value < 0 || scoreTo.value > 10 || scoreTo.value < 0) { 
                this.disableSearch = true;
            }
        }
        else {
            this.disableSearch = false;
        }
        
    }

}