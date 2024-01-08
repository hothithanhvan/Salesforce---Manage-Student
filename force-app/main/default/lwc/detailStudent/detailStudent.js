import { LightningElement, wire, api, track } from 'lwc';
import getScore from '@salesforce/apex/LWC_SearchStudentCtrl.getScore';
import getTerm from '@salesforce/apex/LWC_SearchStudentCtrl.getTerm';
import getAllScore from '@salesforce/apex/LWC_SearchStudentCtrl.getAllScore';

export default class DetailStudent extends LightningElement {

    // Student that receive from Search component
    @api student = {}

    // Display score table or not
    isScore = false

    // Store list score of student
    @track listScore = []

    /** 
    * closeScoreTable
    * Close score table
    * @param studentId
    * @return
    * @created: 2023/08/01 Ho Thi Thanh Van
    * @modified 
    */
    closeScoreTable() {
        this.isScore = false
    }

    // List of term of one student
    listTerm = []

    // List to show term data on view
    termOptions = []

    // Store Id of term that you want to see
    termStudent

    // Disable button "See score" if student has to term to see
    disableSeeScore

    /** 
    * handleTermChange
    * Get value of term on combobox tag
    * @param studentId
    * @return
    * @created: 2023/08/01 Ho Thi Thanh Van
    * @modified 
    */
    async handleTermChange(event) {
        this.termStudent = event.target.value
        this.totalCredit = this.totalScore = 0
        if (this.termStudent == 'All') {
            this.isAllScore = true
            this.isSingleScore = false
        }
        else {
            let result = await getScore({ termId: this.termStudent, studentId: this.student.Id })

            this.listScore = result.map(item => ({
                ...item,
                credit: item.Subject__r.Credit__c
            }))
            console.log(this.listScore);

            for (let i = 0; i < this.listScore.length; i++) {
                this.totalCredit = this.totalCredit + this.listScore[i].credit
                this.totalScore = this.totalScore + this.listScore[i].avgScore__c * this.listScore[i].credit
            }
            this.totalScore = parseFloat(this.totalScore / this.totalCredit).toFixed(1);
            this.termCode = this.listScore[0].Term__r.TermCode__c
            this.isSingleScore = true
            this.isAllScore = false
            this.isScore = true
        }
    }

    /** 
    * getTerm
    * Get all term of a student
    * @param studentId
    * @return
    * @created: 2023/08/01 Ho Thi Thanh Van
    * @modified 
    */
    @wire(getTerm, { studentId: '$student.Id' })
    Term({ data, error }) {
        if (data) {
            this.listTerm = data;
            // console.log(data)
            this.error = undefined;
            let items = [];
            items.push({ label: 'All', value: 'All' })
            for (var i = 0; i < this.listTerm.length; i++) {
                items.push({ label: this.listTerm[i].Term__r.Name, value: this.listTerm[i].Term__r.Id });
            }
            this.termOptions = items;

            if (this.listTerm.length == 0) {
                this.disableSeeScore = true
            }
            else {
                this.disableSeeScore = false
            }
        } else if (error) {
            this.error = error;
            this.listClass = undefined;
        }
    }

    // Total all score
    totalAllScore = 0

    // List to show all scores
    @track listAllScore = []

    /** 
    * getAllScore
    * Get all score in all term of a student
    * @param
    * @return
    * @created: 2023/08/10 Ho Thi Thanh Van
    * @modified 
    */
    async getAllScore() {
        this.isLoading = true
        let listSubject = []
        const data = await getAllScore({ studentId: this.student.Id })
        if (data.length == 0) {
            this.isAllScore = false
        }
        const listTerm = await getTerm({ studentId: this.student.Id })
        let subject = []
        for (let i = 0; i < listTerm.length; i++) {
            for (let j = 0; j < data.length; j++) {
                if (listTerm[i].Term__r.Id == data[j].Term__c) {
                    subject = {
                        name: data[j].Subject__r.Name,
                        process: data[j].ProcessScore__c,
                        midterm: data[j].MidtermScore__c,
                        finalterm: data[j].FinaltermScore__c,
                        avgScore: data[j].avgScore__c.toFixed(1),
                        credit: data[j].Subject__r.Credit__c
                    }
                    listSubject.push(subject)
                }
            }
            let termScore = {
                Id: listTerm[i].Term__r.Id,
                name: listTerm[i].Term__r.Name,
                subject: listSubject,
                avgScore: listTerm[i].TotalScore__c.toFixed(2)
            }
            this.listAllScore.push(termScore)
            listSubject = [];
        }
        
        this.isLoading = false
    }


    connectedCallback() {
        this.getAllScore();
        console.log(this.isExistStudent);

    }

    get isExistStudent() {
        if (this.student == null) {
            return true;
        }
        return false;
    }
    // Show a single term or hide
    isSingleScore = false

    //Show all term or hide
    isAllScore = true

    // Total Score in a term
    totalScore = 0

    // Total credit in a term
    totalCredit = 0

    // Term code
    termCode

    // Loading
    isLoading


}