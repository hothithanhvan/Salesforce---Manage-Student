/**
* Class name        : InsertScoreBatchTest
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/22
*/
@Istest
private class InsertScoreBatchTest 
{

    /**
     * batchTest
     * Test batch insert score
     * @param
     * @return
     * @created: 2023/07/14 Ho Thi Thanh Van
     * @modified
     */
    @IsTest
    static void batchTest(){
        Student__c insertStudent = new Student__c(FirstName__c = 'Nguyện', LastName__c = 'Ngọc', Sex__c = true);
        List<Subject__c> listSubject = new List<Subject__c>();
        List<Term__c> listTerm = new List<Term__c>();
        for (integer i = 0; i < 8; i++)
        {
            Subject__c subject = new Subject__c(Name = 'Toán ' + i, 
                                            ProcessPercent__c = 10, 
                                            MidtermPercent__c = 30, 
                                            FinaltermPercent__c = 60,
                                            Credit__c = 5);
            listSubject.add(subject);
            Term__c term = new Term__c(Name = 'Học kỳ '+i);
            listTerm.add(term);
        }
        insert listSubject;
        insert listTerm;
        insert insertStudent;

        Test.startTest();
        InsertScoreBatch batch = new InsertScoreBatch();
        Id myBatch = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Score__c> listScore = [select id from Score__c ];
        system.assertNotEquals(listScore.size(), 0);
    }
}