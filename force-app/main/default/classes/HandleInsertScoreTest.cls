
/**
* Class name        : HandleInsertScoreTest
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/22
*/
@IsTest
private class HandleInsertScoreTest {

    /**
     * insertScore
     * Test trigger insert score
     * @param 
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void insertScore()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        Subject__c subject = new Subject__c(Name = 'Toán', 
                                            ProcessPercent__c = 10, 
                                            MidtermPercent__c = 30, 
                                            FinaltermPercent__c = 60,
                                            Credit__c = 5);
        insert term;
        insert subject;
        Score__c score = new Score__c(ProcessScore__c = 9, 
                                    MidtermScore__c = 10,
                                    FinaltermScore__c = 10, 
                                    Term__c = term.Id,
                                    Student__c = insertStudent.Id,
                                    Subject__c = subject.Id);
                
        
        Test.startTest();
        insert score;
        Test.stopTest();
        List<Term_student__c> listTermStudent = [select TotalScore__c from Term_Student__c];
        system.assertNotEquals(listTermStudent.size(), 0);
    }

    /**
     * updateScore
     * Test trigger insert score
     * @param 
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void updateScore()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        Subject__c subject = new Subject__c(Name = 'Toán', 
                                            ProcessPercent__c = 10, 
                                            MidtermPercent__c = 30, 
                                            FinaltermPercent__c = 60,
                                            Credit__c = 5);
        insert term;
        insert subject;
        Score__c score = new Score__c(ProcessScore__c = 9, 
                                    MidtermScore__c = 10,
                                    FinaltermScore__c = 10, 
                                    Term__c = term.Id,
                                    Student__c = insertStudent.Id,
                                    Subject__c = subject.Id);
                
        
        Test.startTest();
        insert score;
        score.MidtermScore__c = 5;
        update score;
        Test.stopTest();
        List<Term_student__c> listTermStudent = [select TotalScore__c from Term_Student__c];
        system.assertNotEquals(listTermStudent.size(), 0);
    }

    /**
     * deleteScore
     * Test trigger insert score
     * @param 
     * @return
     * @created: 2023/08/22 Ho Thi Thanh Van
     * @modified 
     */
    static testMethod void deleteScore()
    {
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        insert insertStudent;
        Term__c term = new Term__c(Name = 'Học kỳ 1');
        Subject__c subject = new Subject__c(Name = 'Toán', 
                                            ProcessPercent__c = 10, 
                                            MidtermPercent__c = 30, 
                                            FinaltermPercent__c = 60,
                                            Credit__c = 5);
        insert term;
        insert subject;
        Score__c score = new Score__c(ProcessScore__c = 9, 
                                    MidtermScore__c = 10,
                                    FinaltermScore__c = 10, 
                                    Term__c = term.Id,
                                    Student__c = insertStudent.Id,
                                    Subject__c = subject.Id);
                
        insert score;
        Test.startTest();
        delete score;
        Test.stopTest();

        Student__c student = [select avgScore__c from Student__c where id =: insertStudent.Id limit 1];
        system.assertEquals(student.avgScore__c, 0);
    }
}